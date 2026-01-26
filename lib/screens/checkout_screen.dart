import 'package:flutter/material.dart';
import '../models/gym.dart';

class CheckoutScreen extends StatefulWidget {
  final Gym gym;

  const CheckoutScreen({super.key, required this.gym});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedMethod = 0; // 0 = Pix, 1 = Cartão

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finalizar Compra"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Resumo do Pedido
            const Text("Resumo", style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.gym.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      const Text("1x Day Pass", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                  Text(
                    "R\$ ${widget.gym.dayPassPrice.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // 2. Método de Pagamento
            const Text("Pagamento", style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            
            // Opção Pix
            _buildPaymentOption(
              index: 0,
              icon: Icons.pix,
              title: "Pix (Instantâneo)",
              color: Colors.tealAccent,
            ),
            
            const SizedBox(height: 15),

            // Opção Cartão
            _buildPaymentOption(
              index: 1,
              icon: Icons.credit_card,
              title: "Cartão de Crédito",
              color: Colors.blueAccent,
            ),

            const Spacer(),

            // 3. Botão de Confirmar
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Cor de conversão
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  _showSuccessDialog(context);
                },
                child: const Text("Pagar e Gerar QR Code", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({required int index, required IconData icon, required String title, required Color color}) {
    bool isSelected = _selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? color : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey),
            const SizedBox(width: 15),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.w600)),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent, size: 60),
            SizedBox(height: 10),
            Text("Pagamento Aprovado!", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          "Seu Day Pass está ativo. Apresente o QR Code na recepção.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Fecha Dialog
              Navigator.of(context).popUntil((route) => route.isFirst); // Volta pra Home
            },
            child: const Text("OK, Entendi"),
          ),
        ],
      ),
    );
  }
}