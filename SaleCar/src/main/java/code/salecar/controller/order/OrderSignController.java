package code.salecar.controller.order;

import code.salecar.dao.OrderDAO;
import code.salecar.model.Order;
import code.salecar.model.OrderItem;
import code.salecar.model.User;
import code.salecar.service.product.DigitalSignatureService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "OrderSignController", value = "/sign-order")
public class OrderSignController extends HttpServlet {

    private final DigitalSignatureService sigService = new DigitalSignatureService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("order");
            return;
        }

        try {
            int orderId = Integer.parseInt(idParam);
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);

            if (order == null || order.getUserId() != user.getId()) {
                response.sendRedirect("order");
                return;
            }

            List<OrderItem> items = orderDAO.getOrderItemsByOrderId(orderId);
            order.setItems(items);

            String hashData = sigService.generateOrderHashData(order);

            request.setAttribute("order", order);
            request.setAttribute("hashData", hashData);
            request.setAttribute("verificationStatus", sigService.getVerificationStatus(orderId));

            request.getRequestDispatcher("/pages/sign-order.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("order");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if ("sign".equals(action)) {
            String orderIdStr = request.getParameter("orderId");
            String signature = request.getParameter("signature");

            if (orderIdStr == null || signature == null || signature.trim().isEmpty()) {
                request.getSession().setAttribute("toastMessage", "Please paste the digital signature!");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect("sign-order?id=" + orderIdStr);
                return;
            }

            try {
                int orderId = Integer.parseInt(orderIdStr);

                boolean success = sigService.verifyAndSign(orderId, signature.trim(), user.getId());

                if (success) {
                    request.getSession().setAttribute("toastMessage", "Order signed successfully!");
                    request.getSession().setAttribute("toastType", "success");
                    response.sendRedirect("order-detail?id=" + orderId);
                } else {
                    request.getSession().setAttribute("toastMessage",
                            "Signature verification failed! Make sure you used the correct Private Key.");
                    request.getSession().setAttribute("toastType", "error");
                    response.sendRedirect("sign-order?id=" + orderId);
                }

            } catch (NumberFormatException e) {
                response.sendRedirect("order");
            }

        } else if ("paste".equals(action)) {
            String orderIdStr = request.getParameter("orderId");
            String signature = request.getParameter("signature");

            if (orderIdStr == null || signature == null || signature.trim().isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Signature cannot be empty!\"}");
                return;
            }

            try {
                int orderId = Integer.parseInt(orderIdStr);
                boolean success = sigService.pasteAndVerify(orderId, signature.trim(), user.getId());
                response.setContentType("application/json");

                if (success) {
                    response.getWriter().write("{\"success\": true, \"message\": \"Order signed successfully!\"}");
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"Invalid signature! Make sure you used the correct Private Key.\"}");
                }

            } catch (NumberFormatException e) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid order ID!\"}");
            }
        }
    }
}
