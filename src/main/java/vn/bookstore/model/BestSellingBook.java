package vn.bookstore.model;

/**
 * Model class for best-selling books statistics
 */
public class BestSellingBook {
    private int bookId;
    private String title;
    private int totalSold;

    public BestSellingBook() {
    }

    public BestSellingBook(int bookId, String title, int totalSold) {
        this.bookId = bookId;
        this.title = title;
        this.totalSold = totalSold;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(int totalSold) {
        this.totalSold = totalSold;
    }
}
