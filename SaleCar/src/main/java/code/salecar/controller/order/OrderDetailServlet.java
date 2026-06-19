package code.salecar.controller.order;

import code.salecar.dao.OrderDAO;
import code.salecar.model.Order;
import code.salecar.model.OrderItem;
import code.salecar.model.User;
import code.salecar.service.product.ReviewsService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "order-detail", value = "/order-detail")
public class OrderDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/order");
            return;
        }

        try {
            int orderId = Integer.parseInt(idParam);
            OrderDAO orderDAO = new OrderDAO();
            Order order = null;
            
            try {
                order = orderDAO.getOrderById(orderId);
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("toastMessage", "Lỗi kết nối cơ sở dữ liệu khi tải thông tin đơn hàng.");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/order");
                return;
            }

            if (order != null) {

                List<OrderItem> items = orderDAO.getOrderItemsByOrderId(orderId);
                order.setItems(items);

                User user = (User) request.getSession().getAttribute("user");
                if (user != null) {
                    ReviewsService reviewsService = new ReviewsService();
                    Set<Integer> reviewedProductIds = new HashSet<>();
                    for (OrderItem item : items) {
                        try {
                            if (reviewsService.hasUserReviewedProduct(user.getId(), item.getProductId())) {
                                reviewedProductIds.add(item.getProductId());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    request.setAttribute("reviewedProductIds", reviewedProductIds);
                }

                try {
                    code.salecar.service.product.DigitalSignatureService sigService =
                            new code.salecar.service.product.DigitalSignatureService();
                    java.util.List<code.salecar.service.product.DigitalSignatureService.TamperAlert> tampered =
                            sigService.checkTamperedOrders(user != null ? user.getId() : -1);
                    request.setAttribute("tamperedOrders", tampered);

                    // After the tamper check updated DB statuses, refresh the verification status
                    request.setAttribute("verificationStatus", sigService.getVerificationStatus(orderId));

                    // Synchronize the local order object's verification status
                    for (code.salecar.service.product.DigitalSignatureService.TamperAlert alert : tampered) {
                        if (order.getId() == alert.getOrderId()) {
                            order.setVerificationStatus("Tampered");
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                request.setAttribute("order", order);
                request.getRequestDispatcher("/pages/order-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/order");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/order");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}