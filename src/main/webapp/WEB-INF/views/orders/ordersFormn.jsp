<%@ page import="com.pubble.conpub.domain.SelectedOption" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@include file="../include/header.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div>
    <font size="5" color="red">주문상품</font> <font size="3" color="black">> 배송지 > 결제정보> 결제완료</font>
</div>

<div>
    <h3 class="text-warning">
        주문상품
    </h3>

    <table class="table table-striped">
        <thead>
        <tr>
            <th>상품번호</th>
            <th>상품명</th>
            <th>수량</th>
            <th>단가</th>
            <th>금액</th>
        </tr>
        </thead>

        <tbody>
        <c:set value="0" var="total_price"/>
        <c:forEach items="${orders}" var="order_item">
        <tr>
            <td>${order_item.getItem().getId()}</td>
            <td>
                <c:forEach items="${itemList}" var="i">
                    <c:if test="${i.getId() == order_item.getItem().getId()}">
                        ${i.getItemName()}
                    </c:if>
                </c:forEach>
                <c:if test="${!empty order_item.getAlias()}">
                    별명 : ${order_item.getAlias()}
                </c:if>
            </td>
            <td>${order_item.getAmount()}</td>
            <td>${order_item.getPrice()}</td>
            <td>
                <c:if test="${!empty order_item.getSignaturePage()}">
                    ${order_item.getPrice()*order_item.getAmount()+order_item.getSignaturePage()}

                </c:if>
                ${order_item.getPrice()*order_item.getAmount()}
            </td>
        </tr>
        </c:forEach>
        <tr>
            <td colspan="5" align="right">총: ${total_price} 원</td>
        </tr>
        <tr>
            <td colspan="5" align="right">
                <form method="post" action="/orders/delivery">
                    <input type="hidden" value="${sessionScope.member.id}" name="no">
                    <input type="hidden" value="${orders}" name="o_l">

                    <input type="submit" value="다음">
                    <input type="button" value="취소" onclick="history.go(-1)">
                </form>
            </td>
        </tr>
        </tbody>
    </table>
</div>


<%@include file="../include/footer.jsp" %>