package com.ziJie.crud.controller;


import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ziJie.crud.bean.Employee;
import com.ziJie.crud.bean.Msg;
import com.ziJie.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工crud请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;


    /**
     * 根据id删除员工
     * 单个删除和批量删除
     * @param ids
     * @return
     */
    @RequestMapping(value = "/deleteEmpById/{empIds}")
    @ResponseBody
    public Msg deleteEmpById(@PathVariable("empIds") String ids){

        //多个删除
        if (ids.contains("-")){
            List<Integer> del_ids = new ArrayList<>();
            String[] str_ids = ids.split("-");
            for (String str_id : str_ids) {
                del_ids.add(Integer.parseInt(str_id));
            }
            employeeService.deleteBatch(del_ids);

            //单个删除
        }else {
            int id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }


        return Msg.success();
    }

    /**
     * 员工更新方法
     * @param employee
     * @return
     */
    @RequestMapping(value = "/updateEmp/{empId}")
    @ResponseBody
    public Msg saveEmp(Employee employee){
        System.out.println("=======================" + employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 根据id查询员工
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}" , method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){//@PathVariable("id"):从路径中取出id值

        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp" , employee);
    }

    /**
     * 检查用户名是否可用
     * @param empName
     * @return
     */
    @RequestMapping("/checkEmpName")
    @ResponseBody
    public Msg checkEmpName(@RequestParam("empName") String empName){
        //判断用户名是否符合规则
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        if (!empName.matches(regx)){
            return Msg.fail().add("va-msg" , "用户名必须是2-5位中文或者是6-16为英文和数字的组合用户名可以是2-5位中文或者是6-16为英文和数字的组合");
        }

        //数据库用户名重复校验
        boolean b = employeeService.checkEmpName(empName);
        if (b){
            return Msg.success();
        }else {
            return Msg.fail().add("va-msg","用户名不可用");
        }
    }

    /**
     * 员工保存，只有是post方法才算保存
     * @return
     *
     * 后端校验，因为用户可能会绕过前端校验
     * 后端校验：@Valid注解  BindingResult result
     */
    @RequestMapping(value = "/emp" , method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee , BindingResult result){
        if (result.hasErrors()){
            //后台校验失败，不保存
            //在前端模态框中显示校验错误的失败信息
            Map<String , Object> map = new HashMap<>();
            List<FieldError> fieldErrors = result.getFieldErrors();
            for (FieldError fieldError : fieldErrors) {
                System.out.println("错误的字段名"+fieldError.getField());
                System.out.println("错误的信息"+fieldError.getDefaultMessage());

                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorField" , map);
        }else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }

    }


    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn" , defaultValue = "1")Integer pn , Model model){
        //引入pageHelper分页插件
        //在查询之前只需要调用，传入页码和每页的数量
        PageHelper.startPage(pn , 5); //每页5条数据
        //startPage后的就是分页查询
        List<Employee> emps = employeeService.getAll();

        //使用PageInfo包装查询后的结果，因为pageInfo里面的分页功能完善。只需要将pageInfo交给页面就好了
        //封装了详细的信息，包括查询出来的数据
        PageInfo page = new PageInfo(emps  , 5); //连续显示的页数是5页

        return Msg.success().add("pageInfo", page);
    }

    /**
     * 查询员工数据，分页查询
     * @return
     */
    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn" , defaultValue = "1")Integer pn , Model model){
        //这不是分页查询
//        List<Employee> emps = employeeService.getAll();

        //引入pageHelper分页插件
        //在查询之前只需要调用，传入页码和每页的数量
        PageHelper.startPage(pn , 5); //每页5条数据
        //startPage后的就是分页查询
        List<Employee> emps = employeeService.getAll();

        //使用PageInfo包装查询后的结果，因为pageInfo里面的分页功能完善。只需要将pageInfo交给页面就好了
        //封装了详细的信息，包括查询出来的数据
        PageInfo pageInfo = new PageInfo(emps  , 5); //连续显示的页数是5页
        model.addAttribute("pageInfo" , pageInfo); //包含了查询出的数据

        return "list";
    }
}
















