export function buildWhatsAppLink(baseUrl: string, message: string): string {
  const encoded = encodeURIComponent(message);
  const separator = baseUrl.includes('?') ? '&' : '?';
  return `${baseUrl}${separator}text=${encoded}`;
}

export function buildProductInquiryMessage(productName: string, productId?: string): string {
  const id = productId ? ` (Ref: ${productId})` : '';
  return `Hello UQAAB CARPET, I would like to inquire about the following carpet:${id}\n\nProduct: ${productName}\n\nPlease share pricing and availability. Thank you.`;
}

export function buildGeneralInquiryMessage(): string {
  return 'Hello UQAAB CARPET, I would like to make an inquiry. Please assist me. Thank you.';
}

export function buildWholesaleInquiryMessage(): string {
  return 'Hello UQAAB CARPET, I am interested in wholesale / export pricing. Please share your catalog and bulk order terms. Thank you.';
}
