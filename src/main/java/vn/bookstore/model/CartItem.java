package vn.bookstore.model;

public class CartItem {
    private Book book;
    private int quantity;

    public CartItem(Book book, int quantity) {
        this.book = book;
        this.quantity = quantity;
    }

    public double getLineTotal() {
        return book.getFinalPrice() * quantity;
    }

    public Book getBook() { return book; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
