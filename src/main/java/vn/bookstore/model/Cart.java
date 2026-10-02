package vn.bookstore.model;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {
    private final Map<Integer, CartItem> items = new LinkedHashMap<>();

    public void add(Book book, int qty) {
        int id = book.getId();
        CartItem it = items.get(id);
        if (it == null) items.put(id, new CartItem(book, Math.max(1, qty)));
        else it.setQuantity(it.getQuantity() + Math.max(1, qty));
    }

    public void update(int bookId, int qty) {
        CartItem it = items.get(bookId);
        if (it == null) return;
        if (qty <= 0) items.remove(bookId);
        else it.setQuantity(qty);
    }

    public void remove(int bookId) {
        items.remove(bookId);
    }

    public double getTotal() {
        return items.values().stream().mapToDouble(CartItem::getLineTotal).sum();
    }

    public boolean isEmpty() { return items.isEmpty(); }

    public Collection<CartItem> getItems() { return items.values(); }
}
