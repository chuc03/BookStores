package vn.bookstore.util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Flash message wrapper for temporary notification display.
 * Stored in session and automatically cleared after first display.
 */
public class FlashMessage implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum MessageType {
        SUCCESS("success"), 
        ERROR("danger"), 
        WARNING("warning"), 
        INFO("info");

        private final String bootstrapClass;

        MessageType(String bootstrapClass) {
            this.bootstrapClass = bootstrapClass;
        }

        public String getBootstrapClass() {
            return bootstrapClass;
        }
    }

    private MessageType type;
    private String message;

    public FlashMessage() {
    }

    public FlashMessage(MessageType type, String message) {
        this.type = type;
        this.message = message;
    }

    public MessageType getType() {
        return type;
    }

    public void setType(MessageType type) {
        this.type = type;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getBootstrapAlertClass() {
        return type != null ? "alert alert-" + type.getBootstrapClass() : "alert alert-info";
    }

    /**
     * Container for multiple flash messages.
     */
    public static class FlashMessages {
        private List<FlashMessage> messages = new ArrayList<>();

        public void add(MessageType type, String message) {
            messages.add(new FlashMessage(type, message));
        }

        public void addSuccess(String message) {
            add(MessageType.SUCCESS, message);
        }

        public void addError(String message) {
            add(MessageType.ERROR, message);
        }

        public void addWarning(String message) {
            add(MessageType.WARNING, message);
        }

        public void addInfo(String message) {
            add(MessageType.INFO, message);
        }

        public List<FlashMessage> getMessages() {
            return messages;
        }

        public boolean isEmpty() {
            return messages.isEmpty();
        }

        public void clear() {
            messages.clear();
        }
    }
}
