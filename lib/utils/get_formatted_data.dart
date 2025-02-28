/// Hiển thị nội dung ngắn gọn: 10 ký tự đầu + "..." + 10 ký tự cuối
String getFormattedData(String input) {
  if (input.length <= 25) {
    return input; // Nếu chuỗi ngắn, hiển thị nguyên bản
  }
  return "${input.substring(0, 11)}...${input.substring(input.length - 11)}";
}
