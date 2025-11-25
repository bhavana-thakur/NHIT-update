# Quick Test Guide - Create Account Transfer

## ✅ What's Ready

All models now match your protobuf messages exactly:
- ✅ `CreateAccountTransferRequest`
- ✅ `TransferSourceInput`
- ✅ `TransferDestinationInput`
- ✅ `AccountTransferResponse`

## 🚀 Quick Test (5 minutes)

### Step 1: Start Backend
```bash
# Ensure backend is running at:
http://192.168.1.42:8083/v1
```

### Step 2: Run Flutter App
```bash
flutter run
```

### Step 3: Navigate to Create Transfer
1. Open app
2. Go to Bank RTGS/NEFT section
3. Click "Create Transfer"

### Step 4: Fill Form (Internal One-to-One)
```
Transfer Type: Internal Transfer
Transfer Mode: One to One
Source Account: [Select any account]
Destination Account: [Select any account]
Amount: 10000
Purpose: Test transfer
Remarks: Testing connectivity
```

### Step 5: Submit & Check Console
Look for these logs:
```
🚀 Creating transfer with payload: {transfer_type: INTERNAL, ...}
✅ Response status: 201
✅ Response data: {transfer: {...}}
✅ Parsing AccountTransferResponse (protobuf format)
```

### Step 6: Verify Success
- ✅ SnackBar shows: "Transfer created successfully: TXN-XXX-XXXXX"
- ✅ Check backend database for new transfer record

## 📋 Test Checklist

### Internal Transfers
- [ ] One-to-One: Single source → Single destination
- [ ] One-to-Many: Single source → Multiple destinations
- [ ] Many-to-Many: Multiple sources → Multiple destinations

### External Transfers
- [ ] One-to-One: Single source → Single vendor
- [ ] One-to-Many: Single source → Multiple vendors
- [ ] Many-to-Many: Multiple sources → Multiple vendors

## 🔍 Console Logs Meaning

| Log | Meaning |
|-----|---------|
| 🚀 Creating transfer | Request is being sent |
| ✅ Response status: 201 | Backend accepted request |
| 📦 Raw response data | Shows actual response |
| ✅ Parsing AccountTransferResponse | Successfully parsed protobuf format |
| ❌ Error creating transfer | Something went wrong |

## ⚠️ Common Issues

### "Source total must equal destination total"
**Fix**: Make sure sum of all source amounts = sum of all destination amounts

### "At least one source and destination required"
**Fix**: Add at least one source account and one destination

### "Connection timeout"
**Fix**: Check if backend is running and accessible

### "Invalid response format"
**Fix**: Check console for actual response structure

## 📊 Sample Test Data

### Test 1: Simple Internal Transfer
```
Type: Internal
Mode: One to One
Source: Main Account (10000)
Destination: Savings Account (10000)
```

### Test 2: Multiple Vendors
```
Type: External
Mode: One to Many
Source: Business Account (50000)
Destinations:
  - Vendor A (20000)
  - Vendor B (30000)
```

### Test 3: Complex Transfer
```
Type: Internal
Mode: Many to Many
Sources:
  - Account A (15000)
  - Account B (25000)
Destinations:
  - Account C (10000)
  - Account D (30000)
```

## 🎯 Expected Behavior

### On Success
1. Form submits without errors
2. Loading indicator appears briefly
3. Green SnackBar shows success message
4. Transfer reference is displayed (TXN-XXX-XXXXX)
5. Console shows successful API call

### On Validation Error
1. Red SnackBar shows error message
2. Form stays on screen
3. User can fix and resubmit

### On Network Error
1. Red SnackBar shows connection error
2. Console shows detailed error
3. User can retry

## 📱 Response Structure

Your backend returns:
```json
{
  "transfer": {
    "transferId": "uuid",
    "transferReference": "TXN-XXX-XXXXX",
    "transferType": "INTERNAL|EXTERNAL",
    "transferMode": "ONE_TO_ONE|ONE_TO_MANY|MANY_TO_MANY",
    "totalAmount": 10000,
    "status": "TRANSFER_STATUS_PENDING",
    ...
  }
}
```

Frontend extracts the `transfer` object and shows the `transferReference`.

## ✨ Integration Status

| Component | Status |
|-----------|--------|
| Request Models | ✅ Match protobuf |
| Response Models | ✅ Match protobuf |
| Service Layer | ✅ Handles responses |
| Validation | ✅ All rules implemented |
| Error Handling | ✅ Detailed messages |
| Logging | ✅ Debug-friendly |

## 🎉 You're Ready!

Everything is configured and ready to test. Just run the app and try creating a transfer!

**Need Help?**
- Check `PROTOBUF_INTEGRATION_COMPLETE.md` for detailed documentation
- Check `TRANSFER_API_INTEGRATION_GUIDE.md` for troubleshooting
- Look at console logs for detailed error messages
