package code.salecar.controller.admin.order;

import code.salecar.dao.OrderDAO;
import code.salecar.dao.UserDao;
import code.salecar.model.Order;
import code.salecar.model.OrderItem;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderAdmin", value = "/order-admin")
public class OrderAdmin extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderDAO ordDAO = new OrderDAO();
        UserDao userDao = new UserDao();
        List<Order> lstOrder = new ArrayList<>();
        String errorMessage = null;

        try {
            String searchParam = request.getParameter("search");
            String statusParam = request.getParameter("status");
            String verificationParam = request.getParameter("verification");
            String tamperedParam = request.getParameter("tampered");

            if (searchParam != null && !searchParam.trim().isEmpty()) {
                try {
                    int searchId = Integer.parseInt(searchParam.trim());
                    Order ord = ordDAO.getOrderById(searchId);
                    if (ord != null) {
                        lstOrder.add(ord);
                    }
                } catch (NumberFormatException e) {
                    lstOrder = ordDAO.getAllOrders();
                }
            } else {
                lstOrder = ordDAO.getAllOrders();
            }

            if (statusParam != null && !statusParam.trim().isEmpty()) {
                List<Order> filteredList = new ArrayList<>();
                for (Order ord : lstOrder) {
                    String currentStatus = ord.getOrderStatus();
                    if (currentStatus != null) {
                        if (currentStatus.equalsIgnoreCase(statusParam) ||
                                (statusParam.equals("PENDING") && currentStatus.equalsIgnoreCase("Đang xử lý")) ||
                                (statusParam.equals("CONFIRMED") && currentStatus.equalsIgnoreCase("Đã xác nhận")) ||
                                (statusParam.equals("SHIPPING") && currentStatus.equalsIgnoreCase("Đang vận chuyển")) ||
                                (statusParam.equals("DELIVERED") && currentStatus.equalsIgnoreCase("Đã giao")) ||
                                (statusParam.equals("CANCELLED") && currentStatus.equalsIgnoreCase("Đã hủy"))) {
                            filteredList.add(ord);
                        }
                    }
                }
                lstOrder = filteredList;
            }

            if (verificationParam != null && !verificationParam.trim().isEmpty()) {
                List<Order> filteredList = new ArrayList<>();
                for (Order ord : lstOrder) {
                    String ver = ord.getVerificationStatus();
                    if (ver != null && ver.equalsIgnoreCase(verificationParam)) {
                        filteredList.add(ord);
                    }
                }
                lstOrder = filteredList;
            }

            if (tamperedParam != null && !tamperedParam.trim().isEmpty()) {
                List<Order> filteredList = new ArrayList<>();
                for (Order ord : lstOrder) {
                    String ver = ord.getVerificationStatus();
                    if ("yes".equals(tamperedParam) && "Tampered".equals(ver)) {
                        filteredList.add(ord);
                    } else if ("no".equals(tamperedParam) && !"Tampered".equals(ver)) {
                        filteredList.add(ord);
                    }
                }
                lstOrder = filteredList;
            }

            Map<Integer, String> customerNameMap = new HashMap<>();
            for (Order ord : lstOrder) {
                List<OrderItem> items = ordDAO.getOrderItemsByOrderId(ord.getId());
                ord.setItems(items);

                if (!customerNameMap.containsKey(ord.getUserId())) {
                    String name = userDao.getUserNameById(ord.getUserId());
                    customerNameMap.put(ord.getUserId(), name != null ? name : "Khách hàng ?");
                }
            }

            try {
                code.salecar.service.product.DigitalSignatureService sigService =
                        new code.salecar.service.product.DigitalSignatureService();
                java.util.List<code.salecar.service.product.DigitalSignatureService.TamperAlert> tampered =
                        sigService.checkAllTamperedOrders();
                request.setAttribute("tamperedOrders", tampered);
            } catch (Exception e) {
                e.printStackTrace();
            }

            request.setAttribute("currentSearch", searchParam != null ? searchParam : "");
            request.setAttribute("currentStatus", statusParam != null ? statusParam : "");
            request.setAttribute("orders", lstOrder);
            request.setAttribute("customerNameMap", customerNameMap);

        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Lỗi kết nối cơ sở dữ liệu khi tải danh sách đơn hàng. Vui lòng thử lại sau.";
            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("orders", new ArrayList<Order>());
            request.setAttribute("customerNameMap", new HashMap<Integer, String>());
        }

        request.getRequestDispatcher("/admin/order-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}