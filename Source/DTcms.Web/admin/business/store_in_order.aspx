﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="store_in_order.aspx.cs" Inherits="DTcms.Web.admin.business.store_in_order" %>

<%@ Import Namespace="DTcms.Common" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,initial-scale=1.0,user-scalable=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <title>入库单管理</title>
    <link href="../../scripts/artdialog/ui-dialog.css" rel="stylesheet" type="text/css" />
    <link href="../skin/default/style.css" rel="stylesheet" type="text/css" />
    <link href="../../css/pagination.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" charset="utf-8" src="../../scripts/jquery/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" charset="utf-8" src="../../scripts/artdialog/dialog-plus-min.js"></script>
    <script type="text/javascript" charset="utf-8" src="../../scripts/datepicker/WdatePicker.js"></script>
    <script type="text/javascript" charset="utf-8" src="../js/laymain.js"></script>
    <script type="text/javascript" charset="utf-8" src="../js/common.js"></script>
    <script type="text/javascript">
        function showGoodsDialog(id) {
            var goodsDialog = top.dialog({
                id: 'goodsDialogId',
                title: "入库货物",
                url: 'dialog/dialog_store_in_goods_list.aspx?orderId=' + id,
                width: 700,
                onclose: function () {

                }
            }).showModal();
        }

        function showUnitpriceDialog(id) {
            var attachDialog = top.dialog({
                id: 'unitpriceDialogId',
                title: "单价",
                url: 'dialog/dialog_storein_unitprice_list.aspx?orderId=' + id,
                width: 700
            }).showModal();
        }

        function showCostDialog(id) {
            var costDialog = top.dialog({
                id: 'costDialogId',
                title: "费用项",
                url: 'dialog/dialog_storein_cost_list.aspx?orderId=' + id,
                width: 700
            }).showModal();
        }

        function showRemarkDialog(remark) {
            var objNum = arguments.length;
            var attachDialog = top.dialog({
                id: 'remarkDialogId',
                title: "备注信息",
                content: remark,
                width: 500
            }).showModal();
        }
    </script>
</head>

<body class="mainbody">
    <form id="form1" runat="server">
        <!--导航栏-->
        <div class="location">
            <a href="javascript:history.back(-1);" class="back"><i></i><span>返回上一页</span></a>
            <a href="../center.aspx" class="home"><i></i><span>首页</span></a>
            <i class="arrow"></i>
            <span>入库单列表</span>
        </div>
        <!--/导航栏-->

        <!--工具栏-->
        <div id="floatHead" class="toolbar-wrap">
            <div class="toolbar">
                <div class="box-wrap">
                    <a class="menu-btn"></a>
                    <div class="l-list">
                        <ul class="icon-list">
                            <li><a class="add" href="store_in_order_edit.aspx?action=<%=DTEnums.ActionEnum.Add %>"><i></i><span>新增</span></a></li>
                            <li><a class="all" href="javascript:;" onclick="checkAll(this);"><i></i><span>全选</span></a></li>
                            <li>
                                <asp:LinkButton ID="btnDelete" runat="server" CssClass="del" OnClientClick="return ExePostBack('btnDelete','只允许删除未入库货物，是否继续？');" OnClick="btnDelete_Click"><i></i><span>删除</span></asp:LinkButton></li>
                            <li><asp:LinkButton ID="btnAudit" runat="server" CssClass="lock" OnClientClick="return ExePostBack('btnAudit','审核通过后入库单生效，是否继续？');" onclick="btnAudit_Click"><i></i><span>审核通过</span></asp:LinkButton></li>
                        </ul>
                        <div class="menu-list">
                            <div class="rule-single-select">
                                <asp:DropDownList ID="ddlCustomer" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlCustomer_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div class="rule-single-select">
                                <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                                    <asp:ListItem Text="状态" Value="-1"></asp:ListItem>
                                    <asp:ListItem Text="等待确认" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="等待审核" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="已审核" Value="2"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="r-list">
                        <span class="lable">入库时间</span>
                        <asp:TextBox ID="txtBeginTime" runat="server" CssClass="keyword" onfocus="WdatePicker({ maxDate:'#F{$dp.$D(\'txtEndTime\',{d:-1})}'})"/>
                        <span class="lable">-</span>
                        <asp:TextBox ID="txtEndTime" runat="server" Text="" CssClass="keyword" onfocus="WdatePicker({ minDate:'#F{$dp.$D(\'txtBeginTime\',{d:0})}'})"/>
                        <span class="lable">关键字</span>
                        <asp:TextBox ID="txtKeyWord" runat="server" Text="" CssClass="keyword"/>
                        <asp:LinkButton ID="lbtnSearch" runat="server" CssClass="btn-search" OnClick="btnSearch_Click">查询</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
        <!--/工具栏-->

        <!--列表-->
        <div class="table-container">
            <asp:Repeater ID="rptList" runat="server">
                <HeaderTemplate>
                    <table width="100%" bgoods="0" cellspacing="0" cellpadding="0" class="ltable">
                        <tr>
                            <th width="5%">选择</th>
                            <th align="left">入库单号</th>
                            <th align="left" width="10%">报检号</th>
                            <th align="left">客户</th>
                            <th align="left" width="10%">入库时间</th>
                            <th align="left" width="8%">操作员</th>
                            <th align="left" width="8%">计费数量</th>
                            <th align="left" width="8%">净重</th>
                            <th align="left" width="8%">状态</th>
                            <th width="8%" >备注</th>
                            <th width="12%">明细</th>
                            <th width="8%">操作</th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td align="center">
                            <asp:CheckBox ID="chkId" CssClass="checkall" runat="server" Enabled='<%#Eval("Status").ToString().Equals("2") ? false : true %>' Style="vertical-align: middle;" />
                            <asp:HiddenField ID="hidId" Value='<%#Eval("Id")%>' runat="server" />
                        </td>
                        <td><a href="store_in_order_edit.aspx?action=<%#DTEnums.ActionEnum.Edit %>&id=<%#Eval("Id")%>"><%#Eval("AccountNumber")%></a></td>
                        <td><%#Eval("InspectionNumber")%></td>
                        <td><%#Eval("CustomerName")%></td>
                        <td><%#Convert.ToDateTime(Eval("BeginChargingTime")).ToString("yyyy-MM-dd")%></td>
                        <td><%#Eval("Admin")%></td>
                        <td><%#Eval("ChargingCount")%></td>
                        <td><%#Eval("SuttleWeight")%></td>
                        <td><%#GetStatus(Eval("Status").ToString())%></td>
                        <td align="center"><a href="javascript:void(0);" onclick="showRemarkDialog( '<%#Eval("Remark") %>');">备注</a></td>
                        <td align="center">
                            <a href="javascript:void(0);" onclick="showGoodsDialog(<%#Eval("Id") %>);">入库货物</a>&nbsp;|&nbsp;
                            <a href="javascript:void(0);" onclick="showUnitpriceDialog(<%#Eval("Id") %>);">单价</a>&nbsp;|&nbsp;
                            <a href="javascript:void(0);" onclick="showCostDialog(<%#Eval("Id") %>);">费用项</a>
                        </td>
                        <td align="center">
                            <%#Eval("Status").ToString().Equals("2") ? "修改" : "<a href=\"store_in_order_edit.aspx?action="+DTEnums.ActionEnum.Edit+"&id="+Eval("Id")+"\">修改</a>" %>
                            
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    <%#rptList.Items.Count == 0 ? "<tr><td align=\"center\" colspan=\"11\">暂无记录</td></tr>" : ""%>
</table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
        <!--/列表-->

        <!--内容底部-->
        <div class="line20"></div>
        <div class="pagelist">
            <div class="l-btns">
                <span>显示</span><asp:TextBox ID="txtPageNum" runat="server" CssClass="pagenum" onkeydown="return checkNumber(event);"
                    OnTextChanged="txtPageNum_TextChanged" AutoPostBack="True"></asp:TextBox><span>条/页</span>
            </div>
            <div id="PageContent" runat="server" class="default"></div>
        </div>
        <!--/内容底部-->

    </form>
</body>
</html>
