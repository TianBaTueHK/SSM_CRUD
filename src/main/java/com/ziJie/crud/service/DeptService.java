package com.ziJie.crud.service;

import com.ziJie.crud.bean.Dept;
import com.ziJie.crud.dao.DeptMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DeptService {

    @Autowired
    private DeptMapper deptMapper;

    public List<Dept> getDepts() {

        List<Dept> list = deptMapper.selectByExample(null);

        return list;
    }
}
