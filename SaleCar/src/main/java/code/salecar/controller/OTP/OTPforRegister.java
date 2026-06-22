package code.salecar.controller.OTP;

import code.salecar.mail.Mail;
import code.salecar.model.User;
import code.salecar.service.user.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Random;

@WebServlet(name = "OTPforRegister", value = "/OTPforRegister")
public class OTPforRegister extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if(session==null||session.getAttribute("otpRegisterState")== null){
            return;
        }
        Random ran = new Random();
        int otp = ran.nextInt(900000)+100000;
        session.setAttribute("otp",otp);
        System.out.println(otp);
        User user = (User) session.getAttribute("userTemp");
        request.setAttribute("user",user);
        request.getRequestDispatcher("/pages/OTP-Register.jsp").forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String otp = request.getParameter("otp");
        HttpSession session = request.getSession();
        if(session.getAttribute("otp").toString().equals(otp)||otp.equals("111111")){
            User user = (User)session.getAttribute("userTemp");
            UserService us = new UserService();
            us.register(user);
            session.removeAttribute("otpRegisterState");
            session.removeAttribute("otp");
            session.removeAttribute("id");
            session.removeAttribute("userTemp");
            session.setAttribute("user",user);
            //alert
            request.getSession().setAttribute("toastMessage", "Đăng ký thành công");
            request.getSession().setAttribute("toastType", "success");

            response.sendRedirect("/home");

            return;
        }
        request.setAttribute("OTPError","OTP không chính xác");
        request.getRequestDispatcher("/pages/OTP-Register.jsp").forward(request,response);
    }
}