<%@ page import="com.pubble.conpub.domain.SelectedOption" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@include file="../include/header.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div>
     <font size="3" color="black">주문상품> <font size="5" color="red">배송지</font>> 결제정보> 결제완료</font>
</div>

<div>


     <table class="table table-striped">
     <c:set value="${deliveryInfo}" var="delivery"/>
          <tr>
               <th>주문자</th>
               <td>주문자~</td>
          </tr>
          <tr>
               <th>배송지선택</th>
               <td>
                    <input type="button" value="기본배송지" onclick="">
                    <input type="button" value="신규배송지" onclick="">
                    <input type="button" value="배송지목록" onclick="">
               </td>
          </tr>
          <form action="" method="">
               <tr>
                    <th>이름</th>
                    <td>
                         <input type="text" value="">
                    </td>
               </tr>

               <tr>
                    <th>연락처</th>
                    <td>
                         <input type="text" value="">
                    </td>
               </tr>
               <tr>
                    <th>주소</th>
                    <td>
                         <input type="text" value="우편번호"><input type="button" value="우편번호찾기"><br/>
                         <input type="text" value="주소"><input type="text" value="상세주소">
                    </td>
               </tr>
               <tr>
                    <th>배송시 요청사항</th>
                    <td>
                         <select>
                              <option value="">직접입력</option>
                         </select>
                         <input type="text">
                    </td>
               </tr>







          </form>


     </table>
</div>



<%@include file="../include/footer.jsp" %>