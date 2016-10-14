<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;
%>
<jsp:include page="../header.jsp"></jsp:include>
<style>
    .user-list {
        min-height: 200px;
    }

    .show-user-item {
        margin-right: 10px;

    }

    .show-user-item:hover {
        cursor: pointer;
    }

    .show-user-item > img {
        height: 20px;
        margin-right: 5px;
    }

    .group-user-item {
        margin-right: 10px;
    }

    .group-user-item:hover {
        cursor: pointer;
    }

    .group-user-item > span {
        margin-left: 5px;
        color: black;
    }

    .group-user-item > img {
        height: 20px;
        margin-right: 5px;
    }

    .depList {
        min-height: 200px;
    }

    .bred {
        border: inset #ff2115 1px;
    }
</style>
<div class="content">
    <div class="col-sm-1 shu">
        <a href="#">
            <div>群聊小组</div>
        </a>
    </div>
    <div class="col-sm-11">
        <form action="<%=basePath%>/platform/group/add" id="addGroupForm" method="post" class="form-horizontal">
            <h4>
                新增群组
            </h4>
            <hr>
            <div class="form-group col-sm-12">
                <label for="inputName" class="col-sm-1 control-label">群名 :</label>

                <div class="col-sm-10">
                    <input class="form-control bred" type="text" name="gname" id="inputName" required
                           placeholder="起个有趣的名字吧">
                </div>
            </div>
            <div class="form-group col-sm-12">
                <label for="gdesc" class="col-sm-1 control-label">简介 :</label>

                <div class="col-sm-10">
                    <input class="form-control bred" type="text" name="gdesc" id="gdesc" required
                           placeholder="这是干什么的，详细介绍下">
                </div>
            </div>
            <div class="form-group col-sm-12">
                <label class="col-sm-1 control-label">成员 :</label>

                <div class="col-sm-10">
                    <div class="alert alert-success" id="groupUsers">
                         <span>
                             点击下面方框选择成员：
                          </span>
                    </div>
                </div>
            </div>
            <div class="rows">
                <div class="col-sm-3">
                    <div class="panel panel-warning department">
                        <div class="panel-heading">
                            部门
                        </div>
                        <div class="panel-body depList">
                            <div id="departmentTree" class="ztree">

                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="panel panel-info">
                        <div class="panel-heading">
                            成员
                        </div>
                        <div class="panel-body user-list" id="usersList">

                        </div>
                    </div>
                </div>
                <div class="col-sm-2">
                    <label class="btn btn-success" id="allUsers"> 全选</label>
                    <hr>
                    <button type="submit" id="createSubmit" class="btn btn-primary">创建</button>
                </div>
            </div>
        </form>
    </div>
</div>
<script src="<%=basePath%>/lib/JQuery_z_tree/js/jquery.ztree.core-3.5.min.js"></script>
<%--<script src="<%=basePath%>/lib/JQuery_z_tree/js/jquery.ztree.excheck-3.5.min.js"></script>--%>
<link rel="stylesheet" href="<%=basePath%>/lib/JQuery_z_tree/css/zTreeStyle/zTreeStyle.css">
<script src="<%=basePath%>/js/jquery.validate.min.js"></script>
<script>
    var groupUserArray = [];
    var showUserArray = [];
    $(function () {
        $("#menu li:eq(3)").addClass("active");
        var setting = {

            check: {
                enable: false
            },
            data: {
                simpleData: {
                    enable: true
                }
            },
            callback: {
                onClick: onClick
            }
        };
        $("#allUsers").click(function () {
            if (showUserArray.length != 0) {
                console.log(showUserArray);
                for (var i = 0; i < showUserArray.length; i++) {
                    addGroupUserItem(showUserArray[i].userid, showUserArray[i].username, showUserArray[i].avatar);
                }
            }
        });
        $.ajax({
            url: "<%=basePath%>/platform/addressbook/departmentTree",
            type: "get",
            success: function (data) {
                if (data != null && data.length != 0) {
                    $.fn.zTree.init($("#departmentTree"), setting, data);
                } else {
                    $("#departmentTree").text("空");
                }
            }
        });

        $("#addGroupForm").validate({
            messages: {},
            submitHandler: function (form) {
//                $(form).append('<input type="text" class="hidden" ' + depArray.toString() + '" name="departmentid"/>');
                var $btn = $("#createSubmit").button('loading');
                $(form).ajaxSubmit({
                    data: {
                        "gusers": groupUserArray
                    },
                    dataType: "",
                    success: function (data) {
                        if (data.success) {
                            showTip(data.msg, "success");
                        } else {
                            showTip(data.msg, "failure");
                        }
                        $btn.button('reset');
                        setTimeout(function () {
                            window.location.href = "<%=basePath%>/platform/group";
                        }, 1000);
                        $("#Modal").modal("hide");
                    }
                });
            }
        });
    });
    function onClick(event, treeId, treeNode, clickFlag) {
        checkDep = treeNode;
        $("#allUsers").attr("checked", false);
        showUsers(treeNode.id);
    }

    function showUsers(depId) {
        $.ajax({
            url: "<%=basePath%>/platform/addressbook/getUsersByDepId",
            type: "get",
            data: {
                "depId": depId
            },
            success: function (data) {
                $("#usersList").html("");
                if (data != null && data.length != 0) {
                    showUserArray = data;
                    for (var i = 0; i < data.length; i++) {
                        $("#usersList").append('<label class="label label-info show-user-item" onclick="addGroupUserItem(\'' + data[i].userid + '\',\'' + data[i].username + '\',\'' + data[i].avatar + '\')"><img src="' + data[i].avatar + '">' + data[i].username + '</label>');
                    }
                } else {
                    $("#usersList").text("空");
                }
            }
        });
    }

    function addGroupUserItem(id, name, avatar) {
        var index = groupUserArray.indexOf(id);
        if (index == -1) {
            $("#groupUsers").append('<label class="label label-info group-user-item" onclick="removeGroupUserItem(this,\'' + id + '\')"><img src="' + avatar + '">' + name + '<span>x</span></label>');
            groupUserArray.push(id);
            console.log(groupUserArray);
        }
    }
    function removeGroupUserItem(elem, id) {
        elem.parentNode.removeChild(elem);
        var index = groupUserArray.indexOf(id);
        groupUserArray.splice(index, 1);
        console.log(groupUserArray);
    }
</script>
<jsp:include page="../bottom.jsp"></jsp:include>