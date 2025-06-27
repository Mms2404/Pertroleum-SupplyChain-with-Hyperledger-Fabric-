package org.petroleum;

import com.owlike.genson.annotation.JsonProperty;

public class Batch {
    private String batchID;
    private String origin;
    private String destination;
    private String quantityInBarrels;
    private String owner;
    private String receiver;
    private String status;
    private String timestamp;

    public Batch(@JsonProperty("batchID") String batchID,
                 @JsonProperty("origin") String origin,
                 @JsonProperty("destination") String destination,
                 @JsonProperty("quantityInBarrels") String quantityInBarrels,
                 @JsonProperty("owner") String owner,
                 @JsonProperty("receiver") String receiver,
                 @JsonProperty("status") String status,
                 @JsonProperty("timestamp") String timestamp) {
        this.batchID = batchID;
        this.origin = origin;
        this.destination = destination;
        this.quantityInBarrels = quantityInBarrels;
        this.owner = owner;
        this.receiver = receiver;
        this.status = status;
        this.timestamp = timestamp;
    }

    // Getters
    public String getBatchID() { return batchID; }
    public String getOrigin() { return origin; }
    public String getDestination() { return destination; }
    public String getQuantityInBarrels() { return quantityInBarrels; }
    public String getOwner() { return owner; }
    public String getReceiver() { return receiver; }
    public String getStatus() { return status; }
    public String getTimestamp() { return timestamp; }

    // Setters needed for update functions
    public void setOwner(String owner) { this.owner = owner; }
    public void setReceiver(String receiver) { this.receiver = receiver; }
    public void setStatus(String status) { this.status = status; }
}
