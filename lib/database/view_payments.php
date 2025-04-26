<?php
require_once 'config.php';

$stmt = $conn->query("SELECT * FROM payments ORDER BY created_at DESC");
$payments = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Records</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        tr:hover { background-color: #f5f5f5; }
        .success { color: green; }
        .failed { color: red; }
    </style>
</head>
<body>
    <h1>Payment Records</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>Method</th>
            <th>Amount</th>
            <th>Reference</th>
            <th>Passenger</th>
            <th>Status</th>
            <th>Date</th>
        </tr>
        <?php foreach ($payments as $payment): ?>
        <tr>
            <td><?= htmlspecialchars($payment['id']) ?></td>
            <td><?= htmlspecialchars($payment['payment_method']) ?></td>
            <td>LKR <?= number_format($payment['amount'], 2) ?></td>
            <td><?= htmlspecialchars($payment['reference_id']) ?></td>
            <td><?= htmlspecialchars($payment['passenger_name']) ?></td>
            <td class="<?= $payment['status'] ?>"><?= ucfirst($payment['status']) ?></td>
            <td><?= htmlspecialchars($payment['created_at']) ?></td>
        </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>