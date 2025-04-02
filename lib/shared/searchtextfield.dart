import 'package:flutter/material.dart';

class SearchTextFieldWidget extends StatelessWidget {
    final VoidCallback? onPressed;

  const SearchTextFieldWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color:  Colors.grey.shade600, width: 1.1),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child:  Row(
        children: [
           Icon(Icons.search, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Recherche...',
                border: InputBorder.none,
              ),
            ),
          ),
          // const SizedBox(width: 5,),
         
        IconButton(onPressed: onPressed, icon:  const Icon(Icons.add_circle_outline) )
        ],
      ),
      
    );
  }
}
