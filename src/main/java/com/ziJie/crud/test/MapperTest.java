package com.ziJie.crud.test;

import com.ziJie.crud.bean.Dept;
import com.ziJie.crud.bean.Employee;
import com.ziJie.crud.dao.DeptMapper;
import com.ziJie.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.UUID;

/**
 * 测试dao层
 *
 * 推荐使用spring的项目就可以使用spring的单元测试，可以自动注入我们需要的组件
 */

//@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration(locations = {"classpath:applicationContext.xml"}) //spring的单元测试，指定配置文件的位置，会自动创建IOC容器
public class MapperTest {

//    @Autowired
//    DeptMapper deptMapper;
//
//    @Autowired
//    EmployeeMapper employeeMapper;


    @Test
    public void testCrud(){
//        //1 创建SpringIOC容器
        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
        //2从容器中获取mapper
        DeptMapper deptMapper = ioc.getBean(DeptMapper.class);
        EmployeeMapper employeeMapper = ioc.getBean(EmployeeMapper.class);

        //执行批量操作的SQLSession
        SqlSession sqlSession = ioc.getBean(SqlSession.class);

        //可以打印出来，有没有获得代理
        System.out.println(deptMapper);
        System.out.println(employeeMapper);


        /**
         * 对dept,部门表插入数据
         */
//        deptMapper.insertSelective(new Dept(null,"开发部" ));
        deptMapper.insertSelective(new Dept(null,"销售部" ));

        /**
         * 单条插入员工表数据
         */
//        employeeMapper.insertSelective(new Employee(null , "lh" , "N" , "lh@qq.com" , 1));


        /**
         * 批量插入多个员工
         */
//        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
//        for (int i = 0 ; i <1000 ; i++){
//            String uid = UUID.randomUUID().toString().substring(1, 5) + i;
//            mapper.insertSelective(new Employee(null , uid , "M" , uid+"@ziJie.com" , 1));
//        }
//        System.out.println("批量插入完成");


//        System.out.println(deptMapper);

    }
}

















