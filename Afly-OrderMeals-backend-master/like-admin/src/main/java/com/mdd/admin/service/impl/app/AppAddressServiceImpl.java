package com.mdd.admin.service.impl.app;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.mdd.common.entity.user.UserAddress;
import com.mdd.common.exception.BaseException;
import com.mdd.common.mapper.user.UserAddressMapper;
import com.mdd.common.util.TimeUtils;
import com.mdd.admin.service.app.IAppAddressService;
import com.mdd.admin.validate.app.address.AddressValidate;
import com.mdd.admin.vo.app.address.AddressVo;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
public class AppAddressServiceImpl implements IAppAddressService {

    @Resource
    private UserAddressMapper userAddressMapper;

    @Override
    public List<AddressVo> list(Integer userId) {
        List<UserAddress> addresses = userAddressMapper.selectList(new QueryWrapper<UserAddress>()
                .eq("user_id", userId)
                .eq("is_delete", 0)
                .orderByDesc("is_default")
                .orderByDesc("id"));
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
        long now = TimeUtils.timestamp();
        if (validate.getId() != null && validate.getId() > 0) {
            UserAddress address = getOwnedAddress(validate.getId(), userId);
            BeanUtils.copyProperties(validate, address);
            address.setUpdateTime(now);
            userAddressMapper.updateById(address);
            if (validate.getIsDefault() != null && validate.getIsDefault() == 1) {
                clearDefault(userId);
                address.setIsDefault(1);
                userAddressMapper.updateById(address);
            }
            return;
        }

        if (validate.getIsDefault() != null && validate.getIsDefault() == 1) {
            clearDefault(userId);
        }

        UserAddress address = new UserAddress();
        BeanUtils.copyProperties(validate, address);
        address.setUserId(userId);
        address.setIsDelete(0);
        address.setIsDefault(validate.getIsDefault() == null ? 0 : validate.getIsDefault());
        address.setCreateTime(now);
        address.setUpdateTime(now);
        userAddressMapper.insert(address);
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
        clearDefault(userId);
        UserAddress address = new UserAddress();
        address.setId(id);
        address.setIsDefault(1);
        address.setUpdateTime(TimeUtils.timestamp());
        userAddressMapper.updateById(address);
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

    private void clearDefault(Integer userId) {
        userAddressMapper.update(null, new UpdateWrapper<UserAddress>()
                .eq("user_id", userId)
                .set("is_default", 0));
    }

    private AddressVo toVo(UserAddress address) {
        AddressVo vo = new AddressVo();
        BeanUtils.copyProperties(address, vo);
        vo.setFullAddress(address.getProvince() + address.getCity() + address.getDistrict() + address.getDetail());
        return vo;
    }
}
