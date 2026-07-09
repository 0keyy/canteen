package com.mdd.admin.service.impl.app;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.mdd.admin.config.TencentMapConfig;
import com.mdd.common.entity.user.UserAddress;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.user.UserAddressMapper;
import com.mdd.common.util.StringUtils;
import com.mdd.common.util.TimeUtils;
import com.mdd.admin.service.app.IAppAddressService;
import com.mdd.admin.validate.app.address.AddressValidate;
import com.mdd.admin.vo.app.address.AddressVo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class AppAddressServiceImpl implements IAppAddressService {

    private static final int MAX_ADDRESS_COUNT = 20;

    private static final RestTemplate restTemplate = new RestTemplate();

    @Resource
    private UserAddressMapper userAddressMapper;

    @Resource
    private TencentMapConfig tencentMapConfig;

    @Override
    public List<AddressVo> list(Integer userId) {
        List<UserAddress> addresses = userAddressMapper.selectList(new QueryWrapper<UserAddress>()
                .eq("user_id", userId)
                .eq("is_delete", 0)
                .orderByDesc("is_default")
                .orderByDesc("create_time"));
        List<AddressVo> list = new ArrayList<>();
        for (UserAddress address : addresses) {
            list.add(toVo(address));
        }
        return list;
    }

    @Override
    public AddressVo detail(Integer id, Integer userId) {
        UserAddress address = getOwnedAddress(id, userId);
        return toVo(address);
    }

    @Override
    @Transactional
    public void save(AddressValidate validate, Integer userId) {
        if (StringUtils.isNotEmpty(validate.getLat()) && StringUtils.isNotEmpty(validate.getLng())
                && (StringUtils.isEmpty(validate.getProvince()) || StringUtils.isEmpty(validate.getCity()))) {

            Map<String, String> geoResult = reverseGeocode(validate.getLat(), validate.getLng());
            if (geoResult != null) {
                if (StringUtils.isEmpty(validate.getProvince())) {
                    validate.setProvince(geoResult.get("province"));
                }
                if (StringUtils.isEmpty(validate.getCity())) {
                    validate.setCity(geoResult.get("city"));
                }
                if (StringUtils.isEmpty(validate.getDistrict())) {
                    validate.setDistrict(geoResult.get("district"));
                }
                if (StringUtils.isEmpty(validate.getAddress())) {
                    validate.setAddress(geoResult.get("address"));
                }
            } else {
                throw new BaseException(500, "地址解析失败，请重新选择位置");
            }
        }

        UserAddress model = new UserAddress();
        BeanUtils.copyProperties(validate, model);
        model.setUserId(userId);
        model.setIsDelete(0);
        model.setIsDefault(validate.getIsDefault() != null ? validate.getIsDefault() : 0);
        model.setUpdateTime(System.currentTimeMillis() / 1000);

        if (validate.getId() == null) {
            Long count = userAddressMapper.selectCount(new QueryWrapper<UserAddress>()
                    .eq("user_id", userId)
                    .eq("is_delete", 0));
            if (count >= MAX_ADDRESS_COUNT) {
                throw new BaseException(500, "收货地址最多添加" + MAX_ADDRESS_COUNT + "个");
            }
            model.setCreateTime(System.currentTimeMillis() / 1000);
            userAddressMapper.insert(model);
        } else {
            getOwnedAddress(validate.getId(), userId);
            userAddressMapper.updateById(model);
        }

        if (model.getIsDefault() == 1) {
            clearDefaultExcept(userId, model.getId());
        }
    }

    private Map<String, String> reverseGeocode(String lat, String lng) {
        try {
            String key = tencentMapConfig.getKey();
            if (StringUtils.isEmpty(key)) {
                log.warn("腾讯地图 Key 未配置");
                return null;
            }
            String url = UriComponentsBuilder.fromHttpUrl("https://apis.map.qq.com/ws/geocoder/v1/")
                    .queryParam("location", lat + "," + lng)
                    .queryParam("key", key)
                    .queryParam("get_poi", "0")
                    .build()
                    .toUriString();

            String response = restTemplate.getForObject(url, String.class);

            JSONObject json = JSON.parseObject(response);
            if (json.getInteger("status") == 0) {
                JSONObject result = json.getJSONObject("result");
                JSONObject adInfo = result.getJSONObject("ad_info");

                Map<String, String> map = new HashMap<>();
                map.put("province", adInfo.getString("province"));
                map.put("city", adInfo.getString("city"));
                map.put("district", adInfo.getString("district"));
                map.put("address", result.getString("address"));
                return map;
            }
        } catch (Exception e) {
            log.error("腾讯地图反查失败", e);
        }
        return null;
    }

    @Override
    public void delete(Integer id, Integer userId) {
        UserAddress address = getOwnedAddress(id, userId);
        address.setIsDelete(1);
        address.setUpdateTime(TimeUtils.timestamp());
        userAddressMapper.updateById(address);
    }

    @Override
    @Transactional
    public void setDefault(Integer id, Integer userId) {
        getOwnedAddress(id, userId);
        clearDefaultExcept(userId, id);
        userAddressMapper.update(null, new UpdateWrapper<UserAddress>()
                .eq("id", id)
                .set("is_default", 1)
                .set("update_time", TimeUtils.timestamp()));
    }

    private UserAddress getOwnedAddress(Integer id, Integer userId) {
        UserAddress address = userAddressMapper.selectOne(new QueryWrapper<UserAddress>()
                .eq("id", id)
                .eq("user_id", userId)
                .eq("is_delete", 0));
        if (address == null) {
            throw new BaseException(500, "地址不存在");
        }
        return address;
    }

    private void clearDefaultExcept(Integer userId, Integer excludeId) {
        userAddressMapper.update(null, new UpdateWrapper<UserAddress>()
                .eq("user_id", userId)
                .ne("id", excludeId)
                .set("is_default", 0));
    }

    private AddressVo toVo(UserAddress address) {
        AddressVo vo = new AddressVo();
        BeanUtils.copyProperties(address, vo);
        vo.setFullAddress(String.join(" ",
                StringUtils.nvl(address.getProvince(), ""),
                StringUtils.nvl(address.getCity(), ""),
                StringUtils.nvl(address.getDistrict(), ""),
                StringUtils.nvl(address.getAddress(), ""),
                StringUtils.nvl(address.getDetail(), "")
        ).replaceAll("\\s+", " ").trim());
        return vo;
    }
}
