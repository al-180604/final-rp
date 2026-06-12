# Thesis Restructure Design

## Mục tiêu

Tái cấu trúc báo cáo để người đọc đi theo đúng luồng vận hành của hệ thống:

`Thiết bị Zigbee -> Gateway -> MQTT -> Cloud Backend/Cơ sở dữ liệu/Phân quyền -> Mobile App`.

Trọng tâm của đồ án vẫn là Zigbee, Gateway và luồng Internet of Things (IoT). Cloud Backend, cơ sở dữ liệu, phân quyền và Mobile App được trình bày như các thành phần hỗ trợ để hoàn thiện vòng đời vận hành.

## Nguồn sự thật

- Nội dung và ranh giới chương tuân theo `OUTLINE_GUIDE_IOT_ZIGBEE_THESIS.md`.
- Văn phong, thuật ngữ, bảng, hình và evidence tuân theo `GLOBAL_REPORT_RULES_IOT_ZIGBEE.md`.
- Claim kỹ thuật được kiểm tra từ source hiện tại tại `D:\CODE\zigbee-ble-orchestration-platform`.
- Không ghi kết quả phần cứng là đạt nếu chưa có log, ảnh, phản hồi API hoặc dữ liệu đo. Trường hợp thiếu bằng chứng dùng `\todo{}`.

## Phạm vi chỉnh sửa

### Phân chia công việc

Chia thành hai vùng lớn:

1. Zigbee cục bộ: Coordinator/NCP, End Device đèn, công tắc, cảm biến chuyển động, Gateway và MQTT.
2. Cloud và lớp ứng dụng: FastAPI, REST API, cơ sở dữ liệu, xác thực/phân quyền, Mobile App, kiểm thử và tài liệu.

Hai sinh viên Lê Đức Anh và Chu Thiên Phú cùng tham gia tích hợp, kiểm thử và báo cáo; các đầu việc chính được phân rõ để tránh bảng chung chung.

### Chương 2

- Định nghĩa Smart Building ngay đầu chương.
- Giữ nội dung ở mức lý thuyết, không mô tả chi tiết source.
- Dùng tiêu đề tiếng Việt khi có từ tương đương rõ ràng, ví dụ `Bảo mật` và `Tự động hóa`.
- Giải thích thuật ngữ tiếng Anh hoặc chữ viết tắt ở lần xuất hiện đầu tiên.
- Không trình bày OTA như thành phần đã có trong kiến trúc hoặc triển khai hiện tại.

### Chương 3

- Đặt thiết kế Gateway trước Cloud và Mobile App.
- Gộp Cloud Backend, cơ sở dữ liệu, xác thực và Role-Based Access Control (RBAC) trong cùng một phần.
- Mô tả kiểm soát phạm vi theo nhà/phòng/thiết bị.
- Không tách App, cơ sở dữ liệu hoặc RBAC thành chương độc lập.

### Chương 4

- Viết theo hướng người ít chuyên môn vẫn theo dõi được: mục tiêu của khối, dữ liệu vào, xử lý chính, dữ liệu ra và cách kiểm tra.
- Trình bày lần lượt thiết bị Zigbee, Gateway, Cloud Backend/cơ sở dữ liệu/phân quyền, Mobile App và môi trường demo.
- Giữ sơ đồ kiến trúc, topo và sequence diagram nhưng sửa caption, lời dẫn và phần giải thích để đúng quy tắc.
- Loại nội dung OTA khỏi phần triển khai.

### Chương 5

- Dùng bảng test case có các cột: mã, tên, tóm tắt, thao tác, đầu vào, kết quả mong đợi, kết quả thực tế, đánh giá và evidence.
- Có test case riêng cho Coordinator/NCP, đèn, công tắc và cảm biến chuyển động.
- Có test xuyên suốt cho Cloud, Mobile App, phân quyền, tự động hóa và tình huống mất kết nối.
- Chỉ ghi `Đạt` khi có evidence. Các ô chưa có bằng chứng dùng `\todo{}`.
- OTA được ghi rõ là ngoài phạm vi kiểm thử hiện tại và được đưa sang Chương 6 như một hướng phát triển.

### Chương 6 và toàn báo cáo

- Mô tả OTA, các vai trò RBAC bổ sung và các node chấp hành mới như hướng phát triển, không phải tính năng đã hoàn thành.
- Giới thiệu Jira là công cụ quản lý công việc, Git và GitHub là công cụ quản lý mã nguồn.
- Audit caption: bảng ở trên, hình ở dưới; mỗi bảng/hình có lời dẫn trước và diễn giải sau.

## Sự đánh đổi

- Báo cáo sẽ bớt chi tiết về cấu trúc Flutter và từng cột cơ sở dữ liệu, đổi lại mạch hệ thống rõ hơn và đúng trọng tâm Zigbee/Gateway.
- Test case được mô tả đầy đủ nhưng không tự điền kết quả thực tế khi thiếu evidence. Điều này làm bảng có `\todo{}` nhưng giữ tính trung thực học thuật.
- Phần OTA bị rút khỏi lý thuyết và triển khai hiện tại. Người đọc thấy ranh giới kiểm thử ở Chương 5 và lộ trình thực hiện ở Chương 6.

## Tiêu chí hoàn thành

1. Bảng phân công có hai vùng lớn và tên hai sinh viên.
2. Chương 2 định nghĩa Smart Building ở đầu chương và không còn mục OTA.
3. Chương 3 đi theo thứ tự Gateway -> Cloud/DB/RBAC -> Mobile App.
4. Chương 4 giải thích triển khai theo đầu vào, xử lý và đầu ra; không còn claim OTA.
5. Chương 5 có test case theo từng End Device và không bịa kết quả.
6. Jira, Git và GitHub được giới thiệu đúng vai trò.
7. OTA không bị mô tả như tính năng hiện có; Chương 6 nêu OTA, vai trò RBAC mới và node chấp hành mới như hướng phát triển.
8. PDF build thành công bằng pdfLaTeX.
