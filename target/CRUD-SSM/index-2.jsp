<%--
  Created by IntelliJ IDEA.
  User: 86178
  Date: 2021/1/14
  Time: 16:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%--导入标签库，用户循环插入显示数据--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Title</title>
    <%
        pageContext.setAttribute("APP_PATH" ,  request.getContextPath());
    %>

    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.3.1.js"></script>
    <%--    引入bootstrap样式--%>
    <link href="${APP_PATH}/static/bootstrap_3.3.0/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<body>

<%--员工添加的模态框--%>
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <%--表单--%>
                <form class="form-horizontal">
                    <%--empName--%>
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input"
                                   placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <%--email--%>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input"
                                   placeholder="email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <%--gender--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="ture"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <%--部门信息从数据库中取出--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId" id="dept_add_select">


                            </select>

                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<div class="container">

    <%--    标题行--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>

    <%--    按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button id="emp_add_modal_btn" class="btn btn-primary">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>

        <div></div>
    </div>

    <%--    显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>id</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <%--                <tr>--%>
                <%--                    <th>1</th>--%>
                <%--                    <th>鹿晗</th>--%>
                <%--                    <th>男</th>--%>
                <%--                    <th>lh@qq.com</th>--%>
                <%--                    <th>idol</th>--%>
                <%--                    <td>--%>
                <%--                        <button class="btn btn-primary btn-sm">--%>
                <%--                            <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>--%>
                <%--                            编辑--%>
                <%--                        </button>--%>
                <%--                        <button class="btn btn-danger btn-sm">--%>
                <%--                            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>--%>
                <%--                            删除--%>
                <%--                        </button>--%>
                <%--                    </td>--%>
                <%--                </tr>--%>
                </tbody>

            </table>
        </div>
    </div>

    <%--    显示分页信息--%>
    <div class="row">

        <%--        分页文字信息--%>
        <div class="col-md-6" id="page_info_area">

        </div>

        <%--      分页导航条信息 --%>
        <div class="col-md-6" id="page_nav_area">

        </div>

    </div>

</div>

<script type="text/javascript">

    //声明一个总记录数，用于添加数据后，跳转到最后一页使用
    var totalRecord;

    //页面加载完成以后，直接去发送一个ajax请求，要到分页数据
    $(function () {
        //用户一进来页码，就显示页面的第一页数据
        to_page(1);

    });

    /**
     用户点击了可以跳转的页码，为了获得数据显示，采取的是发送ajax请求
     */
    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"Get",
            dataType:"json",
            success:function (result) {
                console.log(result);
                // 解析并显示员工数据
                build_emps_table(result);
                // 解析显示分页信息
                build_page_info(result);
                //解析显示分页条数据
                build_page_nav(result);
            }
        });
    }


    function build_emps_table(result) {
        /**
         * 每次点击页码后，都会显示上值，所有需要清空上一次的数据，只显示当前页码的数据
         */
        $("#emps_table tbody").empty();

        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index , item) {
            // alert(item.empName);
            var empIdTd = $("<th></th>").append(item.empId);
            var empNameTd = $("<th></th>").append(item.empName);
            var genderTd = $("<th></th>").append(item.gender=='M'?"男":"女");
            var emailTd = $("<th></th>").append(item.email);
            var deptNameTd = $("<th></th>").append(item.dept.deptName);
            /**
             * <button class="btn btn-primary btn-sm">
             <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
             编辑
             </button>
             <button class="btn btn-danger btn-sm">
             <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
             删除
             </button>
             */
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            var delBtn =$("<button></button>").addClass("btn btn-danger btn-sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            var btnTd = $("<td></td>").append(editBtn).append(delBtn);
            //append方法执行完成之后还是返回原来的元素
            $("#emps_table tbody").append("<tr></tr>").append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd).append(" ")
                .append(deptNameTd)
                .append(btnTd)
            // .append("#emps_table");
        });
    }

    //解析显示分页信息
    function build_page_info(result) {
        /**
         * 每次点击页码后，都会显示上值，所有需要清空上一次的数据，只显示当前页码的数据
         */
        $("#page_info_area").empty();

        $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+ " 页 " +
            ", 总 "+result.extend.pageInfo.pages+ "页 " +
            ", 总 "+result.extend.pageInfo.total+"条记录数");

        totalRecord = result.extend.pageInfo.total;
    }

    //分页导航条信息
    function build_page_nav(result) {
        /**
         * 每次点击页码后，都会显示上值，所有需要清空上一次的数据，只显示当前页码的数据
         */
        $("#page_nav_area").empty();

        var ul = $("<ul></ul>").addClass("pagination");

        //构建元素
        var firstPage = $("<li></li>").append($("<a></a>").append("首页").attr("href" , "#"));
        var prePage =  $("<li></li>").append($("<a></a>").append("&laquo;"));

        //如果当前页码有上一页，就显示首页和上一页符号,没有就不显示：disabled,不能点击
        if (result.extend.pageInfo.hasPreviousPage == false){
            firstPage.addClass("disabled");
            prePage.addClass("disabled");
        }else {
            //上一页和末页被禁用了就不需要点击事件了，也可以需要但会销毁一定效率
            //为上一页和首页添加点击事件
            firstPage.click(function () { //首页，所以是去第一页
                to_page(1);
            });
            prePage.click(function () {
                //点击上一页，就是当前页码减一
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }

        var nextPage =  $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPage =  $("<li></li>").append($("<a></a>").append("末页").attr("href" , "#"));
        //如果当前页码有下一页，就显示末页和下一页符号可以点击；没有就不能点击
        if (result.extend.pageInfo.hasNextPage == false){
            nextPage.addClass("disabled");
            lastPage.addClass("disabled");
        }else {

            //为下一页和末页添加点击事件
            lastPage.click(function () {
                //末页，就是去最后一页
                to_page(result.extend.pageInfo.pages);
            });
            nextPage.click(function () {
                //点击下一页，就是当前页码减一
                to_page(result.extend.pageInfo.pageNum + 1);
            });
        }

        ul.append(firstPage).append(prePage);
        //页码号
        $.each(result.extend.pageInfo.navigatepageNums,function (index , item) {
            var numLi =$("<li></li>").append($("<a></a>").append(item));
            //ul里面加li：页码号 1,2,3,4,5
            if (result.extend.pageInfo.pageNum == item){
                numLi.addClass("active"); //当前页码高亮显示。添加元素
            }
            /**
             为li绑定单击事件，可以跳转,去用户点击的页码
             */
            numLi.click(function () {
                to_page(item);
            });

            //ul标签里包含li标签
            ul.append(numLi);
        });
        //添加下一页和末页的提示
        ul.append(nextPage).append(lastPage);

        //把ul添加进nav元素中
        var navEle = $("<nav></nav>").append(ul);

        // navEle.appendTo("#page_nav_area");
        $("#page_nav_area").append(navEle);
    }

    /**
     表单重置的方法
     */
    function reset_form(element){
        //清空表单内容
        $(element)[0].reset();
        //清空表单样式
        $(element).find("*").removeClass("has-error has-success");
        $(element).find(".help-block").text("");
    }

    /**
     点击新增按钮弹出模态框
     */
    $("#emp_add_modal_btn").click(function () {

        //每次点击新增之前，表单充值，清除表单数据和表单样式
        // $("#empAddModal form")[0].reset();
        reset_form("#empAddModal form");

        //发送ajax请求，查出部门信息，显示在下拉列表中
        getDepts();
        //
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });

    //查出所有的部门信息，并显示在下拉列表中
    function getDepts() {
        $.ajax({
            url:"${APP_PATH}/depts",
            type: "Get",
            dataType: "json",
            success:function (result) {
                console.log(result);
                //显示部门信息在下拉列表中
                // $("#dept_add_select"); //方式1
                // $("#empAddModal select").append("") //方式2.因为只有一个select
                $.each(result.extend.depts , function () {
                    var optionElement = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                    $("#empAddModal select").append(optionElement);
                });
            }
        });
    }

    /**
     发送Ajax请求检查保存的用户名是否可用
     */
    $("#empName_add_input").change(function () {
        var empName = this.value;
        $.ajax({
            url:"${APP_PATH}/checkEmpName",
            data:"empName="+empName,
            type:"POST",
            success:function (result) {
                if (result.code == 100){
                    show_validate_msg("#empName_add_input","success","用户名可用");
                    //为保存按钮添加一个成功状态-》可以执行保存操作
                    $("#emp_save_btn").attr("ajax-va","success");
                }else {
                    show_validate_msg("#empName_add_input","error","用户名不可用" );
                    //为保存按钮添加一个状态-》不可以执行保存操作
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        });
    });

    /**
     点击保存员工信息按钮
     */
    $("#emp_save_btn").click(function () {
        //将模态框中填写的表单数据提交给服务器进行保存
        //先要对要交给服务器保存的数据进行校验
        if (!validate_add_form()){
            return false;
        }
        //1 判断之前的用户名校验是否成功，成功则可保存，失败不可以执行保存
        if ($(this).attr("ajax-va")=="error"){
            return false;
        }

        //2 发送ajax请求保存员工
        // alert($("#empAddModal form").serialize()); //序列化，可以直接快捷取出
        $.ajax({
            url:"${APP_PATH}/emp",
            type:"POST",
            dataType:"json",
            //从表单中拿出数据，发给后台
            data: $("#empAddModal form").serialize(),
            success:function (result) {
                // alert(result.msg);


                //员工保存成功后
                //1 关闭模态窗口
                $("#empAddModal").modal('hide');
                //2 来到最后一页，显示刚保存添加的数据
                //发送ajax请求，显示最后一页数据
                to_page(totalRecord); //如果担心很大的话，使用总记录数，肯定是最后一页回
            }
        });
    });

    /**
     * 校验方法
     */
    function validate_add_form() {
        //1 先要拿到表单中要校验的数据，使用正则表达式
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if (!regName.test(empName)){
            // alert("用户名可以是2-5位中文或者是6-16为英文和数字的组合");
            show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或者是6-16为英文和数字的组合");
            // $("#empName_add_input").parent().addClass("has-error");
            // $("#empName_add_input").next("span").text("用户名可以是2-5位中文或者是6-16为英文和数字的组合");
            return false;
        }else {
            //校验成功
            show_validate_msg("#empName_add_input","success","");
            // $("#empName_add_input").parent().addClass("has-success");
            // $("#empName_add_input").next("span").text("");
        }
        //2 校验邮箱
        var empEmail = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})/;
        if (!regEmail.test(empEmail)){
            // alert("邮箱格式错误");
            //应该清空元素之前的样式
            show_validate_msg("#email_add_input","error","邮箱格式错误");
            // $("#email_add_input").parent().addClass("has-error");
            // $("#email_add_input").next("span").text("邮箱格式错误");
            return false;
        }else {
            show_validate_msg("#email_add_input","success","");
            // $("#email_add_input").parent().addClass("has-success");
            // $("#email_add_input").next("span").text("");
        }
        return true;

    }
    /**
     因为多次用到校验的提示信息，所以直接抽离出来，成为一个方法，可以多处直接调用
     */
    function show_validate_msg(element , status , msg) {
        //做校验之前，清除元素状态
        $(element).parent().removeClass("has-success has-error");
        $(element).next("span").text("");

        //校验成功
        if ("success" == status){
            $(element).parent().addClass("has-success");
            $(element).next("span").text("");
        }else if ("error" == status){
            $(element).parent().addClass("has-error");
            $(element).next("span").text(msg);
        }
    }

</script>



</body>
</html>




















