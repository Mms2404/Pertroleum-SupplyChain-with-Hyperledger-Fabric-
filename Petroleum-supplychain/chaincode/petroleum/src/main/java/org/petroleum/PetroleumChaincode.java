package org.petroleum;

import org.hyperledger.fabric.contract.Context;
import org.hyperledger.fabric.contract.ContractInterface;
import org.hyperledger.fabric.contract.annotation.*;
import org.hyperledger.fabric.shim.ChaincodeException;
import org.hyperledger.fabric.shim.ChaincodeStub;
import org.hyperledger.fabric.shim.ledger.KeyValue;  // this and the below one imp 
import org.hyperledger.fabric.shim.ledger.QueryResultsIterator;  // add this import for KeyValue
import com.owlike.genson.Genson;

import java.util.ArrayList;
import java.util.List;

@Contract(name = "PetroleumChaincode")
@Default
public class PetroleumChaincode implements ContractInterface {

    private final Genson genson = new Genson();

    @Transaction(intent = Transaction.TYPE.SUBMIT)
    public void createBatch(Context ctx, String batchID, String origin, String destination, String quantityInBarrels,
                            String owner, String receiver, String status, String timestamp) {

        ChaincodeStub stub = ctx.getStub();

        if (batchExists(ctx, batchID)) {
            throw new ChaincodeException("Batch already exists: " + batchID);
        }

        Batch batch = new Batch(batchID, origin, destination, quantityInBarrels, owner, receiver, status, timestamp);
        String batchJSON = genson.serialize(batch);
        stub.putStringState(batchID, batchJSON);
    }

    @Transaction(intent = Transaction.TYPE.EVALUATE)
    public Batch queryBatch(Context ctx, String batchID) {
        String batchJSON = ctx.getStub().getStringState(batchID);
        if (batchJSON == null || batchJSON.isEmpty()) {
            throw new ChaincodeException("Batch not found: " + batchID);
        }
        return genson.deserialize(batchJSON, Batch.class);
    }

    @Transaction(intent = Transaction.TYPE.SUBMIT)
    public void updateStatus(Context ctx, String batchID, String newStatus) {
        Batch batch = queryBatch(ctx, batchID);
        batch.setStatus(newStatus);  // You will need setters in Batch class or make fields non-final
        ctx.getStub().putStringState(batchID, genson.serialize(batch));
    }

    @Transaction(intent = Transaction.TYPE.SUBMIT)
    public void transferOwnership(Context ctx, String batchID, String newOwner, String newReceiver) {
        Batch batch = queryBatch(ctx, batchID);
        batch.setOwner(newOwner);
        batch.setReceiver(newReceiver);
        ctx.getStub().putStringState(batchID, genson.serialize(batch));
    }

    @Transaction(intent = Transaction.TYPE.EVALUATE)
    public List<Batch> queryAllBatches(Context ctx) {
        List<Batch> batches = new ArrayList<>();
        QueryResultsIterator<KeyValue> results = ctx.getStub().getStateByRange("", "");

        for (KeyValue result : results) {
            Batch batch = genson.deserialize(result.getStringValue(), Batch.class);
            batches.add(batch);
        }
        return batches;
    }

    private boolean batchExists(Context ctx, String batchID) {
        String value = ctx.getStub().getStringState(batchID);
        return value != null && !value.isEmpty();
    }
}
