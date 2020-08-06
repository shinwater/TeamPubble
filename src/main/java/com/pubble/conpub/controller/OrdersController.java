package com.pubble.conpub.controller;

import com.pubble.conpub.domain.Item;
import com.pubble.conpub.domain.Member;
import com.pubble.conpub.domain.SelectedOption;
import com.pubble.conpub.repository.SelectedOptionRepository;
import com.pubble.conpub.service.*;
import jdk.nashorn.internal.ir.RuntimeNode;
import org.apache.jasper.tagplugins.jstl.core.If;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.SessionScope;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class OrdersController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private ItemService itemService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private SelectedOptionService selectedOptionService;

    @Autowired
    private DeliveryService deliveryService;

    //상품페이지에서 바로 '주문하기' 클릭시
    @RequestMapping("/orders/order")
    public String orders(SelectedOption selectedOption, Model model){
        System.out.println(selectedOption.getSize()+"확인"+selectedOption.getAnnalsCoverColor());
        model.addAttribute("selected",selectedOption);
        return "orders/ordersForm1";
    }


    //상품페이지에서 '장바구니' 클릭시 (장바구니에 저장)
    @RequestMapping("/orders/cart")
    public void cart(SelectedOption selectedOption, Model model, @RequestParam("member_no") Long member_no, @RequestParam("no") Long item_no, HttpServletResponse response) throws IOException {


        //selectedOption테이블에 상태를 stored로 저장하기
        Member member = new Member();
        member.setId(member_no);

        Item item = new Item();
        item.setId(item_no);


        selectedOption.setSelectOptionMember(member);
        selectedOption.setItem(item);
        orderService.addCart(selectedOption);

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<script>");
        out.println("var cart=confirm('장바구니에 추가되었습니다. 장바구니로 이동하시겠습니까?')");
        out.println("if (cart==true) { location.href='/order/cartMain?member_no="+member_no+"'}");
        out.println("if (cart==false) { location.href='/'}");
        out.println("</script>");


    }

    //메인페이지에서 '장바구니' 클릭시(장바구니 화면띄우기)
    @RequestMapping("/order/cartMain")
    public String cart(@RequestParam("member_no") Long member_no,Model model,HttpServletResponse response) throws IOException {
        //상품테이블에서 상품리스트가져오기. (item_no에 해당하는 item_name을 구하기위해)
        model.addAttribute("itemList",itemService.findItems());

        //member_no인 멤버 데려오기
        Member member = memberService.findOne(member_no);

        //DB에서 상태가 stored인 데이터만 검색해서 데려오기
        model.addAttribute("cartList",orderService.searchCart(member));
        model.addAttribute("member",member_no);

        return "./orders/cartForm";
    }

    //장바구니에서 수량or별명 변경시
    @RequestMapping("/updateCart")
    public void changeCart(@RequestParam(value = "d",required = false) String d,@RequestParam(value = "value",required = false) String value,
                           @RequestParam(value = "no",required = false) Long no,HttpServletResponse response) throws IOException {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        //해당 장바구니 상품객체 불러오기
        SelectedOption selectedOption=orderService.cartItem(no);

        //불러온 객체에 변경된값 넣어주기
        if(d.equals("alias")){
            selectedOption.setAlias(value);
        }else if(d.equals("amount")){
            selectedOption.setAmount(Integer.parseInt(value));
        }

        //객체저장
        orderService.addCart(selectedOption);

        if(d.equals("amount")){
            out.println(Integer.parseInt(value));
        }
    }

    //장바구니에서 '선택한 상품 삭제' 클릭시
    @RequestMapping("/orders/delete")
    public String delete(@RequestParam("no") Long no, HttpServletRequest request){

        String[] chk_List = request.getParameterValues("chk");
        selectedOptionService.deleteCart(chk_List);


        return "redirect:/order/cartMain?member_no="+no;
    }

   /* @RequestMapping("/orders/delete")
    @ResponseBody
    public String orders(@RequestBody String[] check,HttpServletResponse response,Model model) throws IOException{
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        String[] checkList = new String[check.length-1];
        Long no=Long.parseLong(check[0]);

        for(int i=1;i<check.length;i++){
            checkList[i-1] = check[i];
        }

        //selectedOption테이블에서 selected_no가 일치하는 튜플 삭제.
        selectedOptionService.deleteCart(checkList);

*//*        Member member = memberService.findOne(no);

        out.println(orderService.searchCart(member));*//*

        model.addAttribute("member_no",no);
        return "redirect:/order/cartMain";

    }*/

    //장바구니에서 '선택한 상품 주문' 클릭시
    @RequestMapping("/orders/orders")
    public String ordersItem(@RequestParam("no") Long no, HttpServletRequest request,Model model){
        //상품테이블에서 상품리스트가져오기. (item_no에 해당하는 item_name을 구하기위해)
        model.addAttribute("itemList",itemService.findItems());

        //장바구니에서 선택한 상품들의 selected_no
        String[] chk_List = request.getParameterValues("chk");

        List<SelectedOption> ordersList = new ArrayList<SelectedOption>();
        for(String c :chk_List){
            //SelectedOption 테이블에서 select_no가 일치하는 객체 불러오기
            SelectedOption selectedOption=orderService.cartItem(Long.parseLong(c));
            ordersList.add(selectedOption);

        }

        model.addAttribute("orders",ordersList);
        return "./orders/ordersFormn";

    }

    //주문페이지에서 주문상품확인 후 '다음'버튼 클릭시
    @RequestMapping("/orders/delivery")
    public String checkDelivery(@RequestParam("no") Long member_no,Model model){
        //멤버의 배송지 정보 가져오기.

        System.out.println("여기는 1");
        model.addAttribute("deliveryInfo",deliveryService.findDelivery(member_no));
        System.out.println("여기는 2");

        return "./orders/deliveryConfirmForm";
    }

}
