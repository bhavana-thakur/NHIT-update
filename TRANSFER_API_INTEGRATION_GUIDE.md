# Transfer API Integration Guide

## Overview
The Create Account Transfer form is now fully integrated with your backend API endpoint `/transfers`.

## What Was Updated

### 1. Transfer Model (`transfer_model.dart`)
- **Updated `fromJson`**: Changed field names from snake_case to camelCase to match your backend response:
  - `transfer_id` → `transferId`
  - `transfer_reference` → `transferReference`
  - `transfer_type` → `transferType`
  - etc.
- **Updated timestamp parsing**: Changed from protobuf timestamp format to ISO 8601 string format
- **Updated `toJson`**: Ensures proper serialization matching backend expectations

### 2. Account Transfer Service (`account_transfer_service.dart`)
- **Enhanced error handling**: Added detailed logging for debugging
- **Flexible response parsing**: Handles multiple response formats:
  - Wrapped response: `{ "transfer": {...} }`
  - Array response: `{ "transfers": [{...}] }`
  - Direct response: `{ "transferId": "...", ... }`
- **Validation**: Validates request before sending to backend
- **Retry logic**: Includes retry with backoff for transient failures

## Backend Response Structure (Confirmed)
```json
{
  "transfers": [
    {
      "transferId": "e03506cf-f90c-4414-92db-033b21e54f0f",
      "transferReference": "TXN-EXT-1763533964",
      "transferType": "EXTERNAL",
      "transferMode": "MANY_TO_MANY",
      "totalAmount": 400000,
      "purpose": "Project-wide payouts to external contractors",
      "remarks": "Stage 3 completion payments",
      "status": "TRANSFER_STATUS_PENDING",
      "requestedById": "550e8400-e29b-41d4-a716-446655440101",
      "approvedById": "",
      "approvedAt": null,
      "completedAt": null,
      "bankLetterReference": "",
      "bankLetterStatus": "",
      "bankLetterGeneratedAt": null,
      "createdAt": "2025-11-19T06:32:44.151536Z",
      "updatedAt": "2025-11-19T06:32:44.151536Z",
      "transferLegs": [],
      "requestedBy": {
        "id": "550e8400-e29b-41d4-a716-446655440101",
        "name": "User",
        "email": "user@example.com"
      },
      "approver": null
    }
  ]
}
```

## Request Payload Structure
The frontend sends this structure to the backend:

```json
{
  "transfer_type": "EXTERNAL",
  "transfer_mode": "MANY_TO_MANY",
  "purpose": "Project-wide payouts",
  "remarks": "Stage 3 completion",
  "requested_by_id": "550e8400-e29b-41d4-a716-446655440101",
  "sources": [
    {
      "source_account_id": "account-uuid-1",
      "amount": 200000
    },
    {
      "source_account_id": "account-uuid-2",
      "amount": 200000
    }
  ],
  "destinations": [
    {
      "destination_vendor_id": "vendor-uuid-1",
      "amount": 150000
    },
    {
      "destination_vendor_id": "vendor-uuid-2",
      "amount": 250000
    }
  ]
}
```

## Testing Steps

### 1. Verify Backend Connectivity
```bash
# Test if backend is reachable
curl http://192.168.1.42:8083/v1/transfers
```

### 2. Test Transfer Creation

#### Internal Transfer (One-to-One)
1. Open Create Transfer page
2. Select "Internal Transfer"
3. Select "One to One" mode
4. Fill in:
   - Source Account: Select an account
   - Destination Account: Select an account
   - Amount: Enter amount (e.g., 10000)
   - Purpose: "Test internal transfer"
   - Remarks: "Testing"
5. Click "Create Transfer"
6. Check console logs for:
   ```
   🚀 Creating transfer with payload: {...}
   ✅ Response status: 200
   ✅ Response data: {...}
   📦 Parsing transfer from...
   ```

#### External Transfer (One-to-Many)
1. Select "External Transfer"
2. Select "One to Many" mode
3. Fill in:
   - Source Account: Select an account
   - Click "Add Vendor" to add vendor rows
   - For each vendor: Select vendor and enter amount
   - Purpose: "Test external transfer"
   - Remarks: "Testing"
4. Click "Create Transfer"

#### Many-to-Many Transfer
1. Select transfer type (Internal or External)
2. Select "Many to Many" mode
3. Add multiple source accounts with amounts
4. Add multiple destinations (accounts or vendors) with amounts
5. Ensure total source amount equals total destination amount
6. Click "Create Transfer"

### 3. Check Validation
The form validates:
- ✅ At least one source and one destination
- ✅ Source total equals destination total
- ✅ All amounts are greater than 0
- ✅ Internal transfers have destination account IDs
- ✅ External transfers have destination vendor IDs

### 4. Monitor Console Output
When you submit a transfer, check the console for:

**Success:**
```
🚀 Creating transfer with payload: {transfer_type: INTERNAL, ...}
✅ Response status: 201
✅ Response data: {transfers: [{transferId: ..., ...}]}
📦 Parsing transfer from transfers array
```

**Validation Error:**
```
❌ Error creating transfer: Source total (₹10000.0) must equal destination total (₹15000.0)
```

**Network Error:**
```
❌ Error creating transfer: DioException [connection timeout]: ...
```

## Common Issues and Solutions

### Issue 1: Data Not Posting
**Symptom**: Form submits but no API call is made
**Solution**: 
- Check if `_isSubmitting` is stuck at `true`
- Verify `_formKey.currentState!.validate()` returns true
- Check console for validation errors

### Issue 2: Response Parsing Error
**Symptom**: "Invalid response format" error
**Solution**:
- Check console logs for actual response structure
- Backend might be returning a different format
- Update service to handle the specific format

### Issue 3: Network Timeout
**Symptom**: Connection timeout errors
**Solution**:
- Verify backend is running: `curl http://192.168.1.42:8083/v1/transfers`
- Check if device is on same network as backend
- Increase timeout in `api_client.dart` if needed

### Issue 4: Validation Errors
**Symptom**: "Source total must equal destination total"
**Solution**:
- Ensure all amounts are entered correctly
- Check for rounding errors in decimal amounts
- Verify all required fields are filled

## API Configuration

### Base URL
Located in `lib/features/bank_rtgs_neft/services/api_client.dart`:
```dart
static const String baseUrl = 'http://192.168.1.42:8083/v1';
```

### Endpoints Used
- **POST** `/transfers` - Create new transfer
- **GET** `/transfers/{id}` - Get transfer details
- **POST** `/transfers/{id}/cancel` - Cancel transfer

### Headers
```dart
{
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Idempotency-Key': '<timestamp>',
  'X-Request-Source': 'create-transfer-page'
}
```

## Success Indicators

✅ **Form Submission**: SnackBar shows "Transfer created successfully: TXN-XXX-XXXXX"
✅ **Console Logs**: Shows payload, response status, and parsed transfer
✅ **Backend**: Transfer appears in database with correct status
✅ **Navigation**: User can navigate to transfer details (when implemented)

## Next Steps

1. **Test with Real Data**: Use actual account and vendor IDs from your backend
2. **Implement Navigation**: Add navigation to transfer details page after creation
3. **Add Loading States**: Show loading indicator during API call
4. **Error Recovery**: Add retry button for failed submissions
5. **Offline Support**: Consider caching failed requests for retry

## Support

If you encounter issues:
1. Check console logs for detailed error messages
2. Verify backend is running and accessible
3. Test API endpoint directly with curl/Postman
4. Check network connectivity
5. Review validation rules in `CreateAccountTransferRequest.validate()`
