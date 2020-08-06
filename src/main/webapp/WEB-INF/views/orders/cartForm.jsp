<%@ page import="com.pubble.conpub.domain.SelectedOption" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="../include/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<script>
    //별명, 수량 변경
    function alias_change(cartNo) {
        var aliasValue = "#updateAlias"+cartNo

        $.ajax({
            method: "post",
            data: {"d":"alias","value":$(aliasValue).val(),"no":cartNo},
            url: "/updateCart",
            success: function (data) {
                alert('별명이 변경되었습니다.')
            }
        })
    }

    function amount_change(cartNo) {
        var amountValue= "#updateAmount"+cartNo;

        $.ajax({
            method: "post",
            data: {"d":"amount","value":$(amountValue).val(),"no":cartNo},
            url: "/updateCart",
            success: function (data) {

                var addr_total_price = "item_price"+cartNo;
                var addr_price = "#price"+cartNo;
                var addr_signature = "#signature"+cartNo;

                document.getElementById(addr_total_price).innerHTML=data * $(addr_price).val() + parseInt($(addr_signature).val());
            }
        })
    }


    //체크박스

    var total_price = 0;


    /*하나의 체크박스 선택*/
    $(document).ready(function(){


        $("input:checkbox").on('click', function(){
            if ( $(this).prop('checked') ) {
                var addr_item_price = "#item_price"+this.id.substring(8);

                total_price += parseInt($(addr_item_price).text());
                document.getElementById("orderCash").innerHTML=total_price;

            } else {
                total_price -= parseInt($("#item_price"+this.id.substring(8)).text());
                document.getElementById("orderCash").innerHTML=total_price;
            }
        });
    });



    /*전체 체크박스 선택*/
    $(function () {
        $("#allCheck").click(function(){
            //클릭되었으면
            if($("#allCheck").prop("checked")){
                //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 true로 정의
                $("input[name=chk]").prop("checked",true);


                total_price=0;

                $("input[name=chk]:checked").each(function() {

                    var addr_item_price = "#item_price"+this.id.substring(8);

                    total_price += parseInt($(addr_item_price).text());
                    document.getElementById("orderCash").innerHTML=total_price;
                })

                //클릭이 안되있으면
            }else{
                //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 false로 정의
                $("input[name=chk]").prop("checked",false);

                total_price = 0;
                document.getElementById("orderCash").innerHTML=total_price;
            }
        })
    })


/*    function delete_cart() {

        var check = new Array();
        check.push(멤버넘버);

        $("input[name=chk]:checked").each(function() {
            check.push($(this).val());
        })

        $.ajax({
            method:"post",
            url:"/orders/delete",
            contentType:"application/json; charset=UTF-8",
            data: JSON.stringify(check),
            async: false,
            success: function (data) {

                //data에는 로그인한 회원의 갱신 장바구니 정보가 담겨있음.
                alert(data);
            }
        })
    }*/

</script>



<div>
    <h3 class="text-warning">
        장바구니
    </h3>

<form method="post">

    <table class="table table-striped">
        <thead>
        <tr>
            <th>
                <input type="checkbox" id="allCheck">
            </th>
            <th>상품번호</th>
            <th>상품명</th>
            <th></th>
            <th>수량</th>
            <th>단가</th>
            <th>금액</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${cartList}" var="cart">

            <tr>
                <td><input type="checkbox" name="chk" value="${cart.getId()}" id="checkbox${cart.getId()}"></td>

                <td>
                        ${cart.getItem().getId()}
                    <input type="hidden" value="${cart.getId()}" id="cart_no">
                </td>

                <td>
                    <c:forEach items="${itemList}" var="i">
                        <c:if test="${i.getId() == cart.getItem().getId()}">
                            ${i.getItemName()}
                        </c:if>
                    </c:forEach>
                </td>
                <td>
                    별명:
                    <input type="text" id="updateAlias${cart.getId()}" value="${cart.getAlias()}" name="alias">
                    <input type="button" onclick="alias_change(${cart.getId()});" value="변경">

                </td>
                <td>
                    <input type="text" id="updateAmount${cart.getId()}" value="${cart.getAmount()}" name="amount">
                    <input type="button" onclick="amount_change(${cart.getId()});" value="변경">

                </td>
                <td>
                        ${cart.getPrice()}
                    <input type="hidden" value="${cart.getPrice()}" id="price${cart.getId()}">
                    <input type="hidden" value="${cart.getSignature()}" id="signature${cart.getId()}">
                </td>
                <td>
                    <span id="item_price${cart.getId()}">${cart.getAmount()*cart.getPrice()+cart.getSignature()}</span>

                </td>
            </tr>
        </c:forEach>
        <tr>
            <td colspan="7" align="right"><b>총 </b><span id="orderCash"></span> 원</td>
        </tr>
        <tr>
            <td colspan="7">
                <input type="hidden" value="${sessionScope.member.id}" name="no">
                <input type="submit" value="선택한 상품 삭제" onclick="javascript: form.action='/orders/delete';">
                <input type="submit" value="선택한 상품 주문" onclick="javascript: form.action='/orders/orders';">
            </td>
        </tr>
        </tbody>
    </table>
</form>
</div>

<%@include file="../include/footer.jsp" %>