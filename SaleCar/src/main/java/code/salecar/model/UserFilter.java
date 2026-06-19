package code.salecar.model;

/**
 * Holds all search, filter, sort and pagination criteria for the
 * admin user management screen (/filterUser).
 *
 * Any field left null/blank is treated as "no constraint".
 */
public class UserFilter {
    private String keyword;      // searches username, fullname, email, phonenumber
    private String role;         // "admin" | "user" | null/"" = all
    private Boolean status;      // true = active, false = locked, null = all
    private String dateFrom;     // registration date lower bound (yyyy-MM-dd), inclusive
    private String dateTo;       // registration date upper bound (yyyy-MM-dd), inclusive
    private String sortBy;       // logical sort key: "id" | "fullname"
    private String sortDir;      // "asc" | "desc"
    private int page = 1;        // 1-based page index
    private int pageSize = 20;   // rows per page

    public UserFilter() {
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public String getDateFrom() {
        return dateFrom;
    }

    public void setDateFrom(String dateFrom) {
        this.dateFrom = dateFrom;
    }

    public String getDateTo() {
        return dateTo;
    }

    public void setDateTo(String dateTo) {
        this.dateTo = dateTo;
    }

    public String getSortBy() {
        return sortBy;
    }

    public void setSortBy(String sortBy) {
        this.sortBy = sortBy;
    }

    public String getSortDir() {
        return sortDir;
    }

    public void setSortDir(String sortDir) {
        this.sortDir = sortDir;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    /** Convenience: 0-based offset for SQL LIMIT/OFFSET. */
    public int getOffset() {
        return (page - 1) * pageSize;
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    public boolean hasKeyword() {
        return !isBlank(keyword);
    }

    public boolean hasRole() {
        return !isBlank(role);
    }

    public boolean hasStatus() {
        return status != null;
    }

    public boolean hasDateFrom() {
        return !isBlank(dateFrom);
    }

    public boolean hasDateTo() {
        return !isBlank(dateTo);
    }
}
