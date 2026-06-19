package code.salecar.controller.order;

import code.salecar.dao.OrderDAO;
import code.salecar.model.Order;
import code.salecar.model.OrderItem;
import code.salecar.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.imageio.IIOException;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "order", value = "/order")
public class order extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        List<Order> lstOrder = new java.util.ArrayList<>();
        String errorMessage = null;

        try {
            OrderDAO ordDAO = new OrderDAO();
            lstOrder = ordDAO.getOrdersByUserId(user.getId());

            for (Order order : lstOrder) {
                List<OrderItem> items = ordDAO.getOrderItemsByOrderId(order.getId());
                order.setItems(items);
            }

            try {
                code.salecar.service.product.DigitalSignatureService sigService =
                        new code.salecar.service.product.DigitalSignatureService();
                java.util.List<code.salecar.service.product.DigitalSignatureService.TamperAlert> tampered =
                        sigService.checkTamperedOrders(user.getId());
                request.setAttribute("tamperedOrders", tampered);

                // After the tamper check updated DB statuses, synchronize the local order objects
                for (code.salecar.service.product.DigitalSignatureService.TamperAlert alert : tampered) {
                    for (Order ord : lstOrder) {
                        if (ord.getId() == alert.getOrderId()) {
                            ord.setVerificationStatus("Tampered");
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Lỗi kết nối cơ sở dữ liệu khi tải danh sách đơn hàng. Vui lòng thử lại sau.";
            request.getSession().setAttribute("toastMessage", errorMessage);
            request.getSession().setAttribute("toastType", "error");
        }

        request.setAttribute("orders", lstOrder);
        request.getRequestDispatcher("/pages/order.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
