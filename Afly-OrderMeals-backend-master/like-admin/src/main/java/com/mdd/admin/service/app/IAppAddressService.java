package com.mdd.admin.service.app;

import com.mdd.admin.validate.app.address.AddressValidate;
import com.mdd.admin.vo.app.address.AddressVo;

import java.util.List;

public interface IAppAddressService {

    List<AddressVo> list(Integer userId);

    AddressVo detail(Integer id, Integer userId);

    void save(AddressValidate validate, Integer userId);

    void delete(Integer id, Integer userId);

    void setDefault(Integer id, Integer userId);
}
