package com._company_._project_.exception;

/**
 * Created by yamingd on 9/24/15.
 */
public class ServiceException extends Exception {

    private int errorCode = 60500;

    public ServiceException(String message, int errorCode) {
        super(message);
        this.errorCode = errorCode;
    }

    public ServiceException(String message, Throwable cause, int errorCode) {
        super(message, cause);
        this.errorCode = errorCode;
    }

    public ServiceException(Throwable cause, int errorCode) {
        super(cause);
        this.errorCode = errorCode;
    }

    public ServiceException(int errorCode) {
        this.errorCode = errorCode;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }
}
