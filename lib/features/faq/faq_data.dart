class FAQItem {
  final String category;
  final String question;
  final String answer;

  FAQItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}

const String ans =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum';

final List<FAQItem> faqItems = [
  FAQItem(category: 'General FAQ', question: 'About Us', answer: ans),
  FAQItem(
    category: 'General FAQ',
    question: 'How does Kasut work?',
    answer: ans,
  ),
  FAQItem(
    category: 'General FAQ',
    question: 'How is the authentication process at Kasut?',
    answer: ans,
  ),
  FAQItem(
    category: 'General FAQ',
    question: 'What is the pricing method at Kasut?',
    answer: ans,
  ),
  FAQItem(
    category: 'General FAQ',
    question: 'How to register in Kasut?',
    answer: ans,
  ),
  FAQItem(
    category: 'General FAQ',
    question: 'How do I contact Kasut?',
    answer: ans,
  ),
  FAQItem(category: 'General FAQ', question: 'Kasut Point', answer: ans),
  FAQItem(category: 'General FAQ', question: 'Referral Code', answer: ans),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'How to make a purchase?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'What payment methods are available?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'Can I apply for installments?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'Can I cancel my order?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'How long does it take for the goods to be delivered?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'How do I return the items?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'What is the refund process for your order issue?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'Can I track orders in progress?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'Can I make an offer on certain products?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'Can I file a complaint?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'I have placed an order. but I did not get a confirmation email.',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'How much is the shipping cost for each product?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'Can I change my address once the order has been placed?',
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: "What happens if I don't send the item I want to return?",
    answer: ans,
  ),
  FAQItem(
    category: 'Purchase, Payment dan Delivery',
    question: 'Processing Fee',
    answer: ans,
  ),
  FAQItem(
    category: 'Selling in Kasut',
    question: 'Can I cancel my sale?',
    answer: ans,
  ),
  FAQItem(
    category: 'Selling in Kasut',
    question: 'When will I get the proceeds of my sales?',
    answer: ans,
  ),
  FAQItem(
    category: 'Selling in Kasut',
    question: "What happens if I don't confirm the sale?",
    answer: ans,
  ),
  FAQItem(
    category: 'Selling in Kasut',
    question: 'How long does the authentication process take at Kasut?',
    answer: ans,
  ),
  FAQItem(
    category: 'Selling in Kasut',
    question: 'What happens if my item does not pass authentication?',
    answer: ans,
  ),
  FAQItem(
    category: 'Selling in Kasut',
    question: "Why is my item cancelled?",
    answer: ans,
  ),
  FAQItem(
    category: 'Selling in Kasut',
    question: 'Why is my account suspended?',
    answer: ans,
  ),
  FAQItem(
    category: 'Selling in Kasut',
    question:
        'How long does it take to disburse the proceeds to your personal account?',
    answer: ans,
  ),
  FAQItem(
    category: 'Selling in Kasut',
    question: "How do I pay the penalty fee?",
    answer: ans,
  ),
  FAQItem(
    category: 'Selling in Kasut',
    question: "Seller Takeout",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "Account Data Deletion",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "General Terms",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "Buyer Terms",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "Seller Terms",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "Authenticity and Verification Process",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "Limitation of Liability",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "Account and Security",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "Dispute Resolution",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "Intellectual Property",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "Contact Information",
    answer: ans,
  ),
  FAQItem(
    category: 'Terms and Conditions',
    question: "Acceptance",
    answer: ans,
  ),
  FAQItem(
    category: 'Standard Product Details',
    question: "Defect Guideline",
    answer: ans,
  ),
  FAQItem(category: 'Payment methods', question: "Credit Card", answer: ans),
  FAQItem(category: 'Payment methods', question: "Atome", answer: ans),
  FAQItem(
    category: 'Payment methods',
    question: "Virtual Account",
    answer: ans,
  ),
  FAQItem(category: 'Payment methods', question: "Kredivo", answer: ans),
  FAQItem(category: 'Events', question: "New User Voucher", answer: ans),
  FAQItem(category: 'Tickets', question: "Payment", answer: ans),
  FAQItem(
    category: 'Tickets',
    question: "Cancellation / Refund Policy",
    answer: ans,
  ),
  FAQItem(
    category: 'Consignment',
    question: "Consignment at Kasut",
    answer: ans,
  ),
  FAQItem(
    category: 'Consignment',
    question: "LuxKasut Consignment",
    answer: ans,
  ),
  FAQItem(category: 'Privacy Policy', question: "Privacy Policy", answer: ans),
];
