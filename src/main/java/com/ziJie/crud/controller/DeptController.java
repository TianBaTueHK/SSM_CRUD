package com.ziJie.crud.controller;


import com.ziJie.crud.bean.Dept;
import com.ziJie.crud.bean.Employee;
import com.ziJie.crud.bean.Msg;
import com.ziJie.crud.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理和部门有关的请求
 */
@Controller
public class DeptController {

    @Autowired
    private DeptService deptService;




    /**
     * 查询新增下拉框中部门的值，返回前端填充到下拉框中
     * @return
     */
    @RequestMapping("/depts")
    @ResponseBody
    public Msg getDepts(){

        //查出的所有部门信息
        List<Dept> list = deptService.getDepts();

        return Msg.success().add("depts" , list);
    }




}














