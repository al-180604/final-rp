# RULE GLOBAL DỰ ÁN — Quy tắc viết báo cáo ĐATN IoT Zigbee Smart Building

> Mục đích: file này là bộ luật cho AI Agent khi viết, sửa, audit hoặc tái cấu trúc báo cáo đồ án tốt nghiệp cử nhân.  
> Phạm vi áp dụng: báo cáo ĐATN về hệ thống IoT/Zigbee/Gateway/Cloud/App, theo mẫu HUST và văn phong học thuật kỹ thuật.

---

## 0. Thứ tự ưu tiên khi có xung đột

AI Agent phải ưu tiên theo thứ tự sau:

1. **Mẫu chính thức của Trường/Khoa/Bộ môn** đang được dùng cho ĐATN.
2. **Yêu cầu trực tiếp của giảng viên hướng dẫn / hội đồng / mentor**.
3. **Quy tắc trong file này**.
4. **Quy tắc citation và academic writing bên ngoài**, ví dụ IEEE/Purdue, chỉ dùng để bổ sung khi mẫu trường chưa nói rõ.

Nếu có xung đột, không tự đoán. Ghi rõ: `CẦN XÁC NHẬN: ...`.

---

## 1. Nguyên tắc cốt lõi

Báo cáo không phải nhật ký code. Báo cáo phải chứng minh được 4 điều:

| Câu hỏi | Báo cáo phải trả lời |
|---|---|
| Làm gì? | Hệ thống giải quyết vấn đề gì, phạm vi đến đâu |
| Vì sao làm vậy? | Lý do chọn Zigbee, Gateway, MQTT, Cloud, App, thiết kế rule |
| Làm như thế nào? | Kiến trúc, data flow, module, giao thức, triển khai |
| Kết quả ra sao? | Test case, log, ảnh, video, chỉ số, hạn chế, hướng phát triển |

Không viết kiểu “em đã làm nhiều phần”. Phải viết kiểu “module X nhận dữ liệu từ Y, xử lý Z, và được kiểm chứng bằng test case T”.

---

## 2. Quy tắc văn phong

### 2.1. Văn phong bắt buộc

Dùng văn phong học thuật kỹ thuật:

- Rõ ràng, chính xác, có chủ ngữ.
- Ưu tiên câu ngắn đến trung bình.
- Mỗi đoạn chỉ nên tập trung vào một ý chính.
- Tránh cảm tính, tránh phóng đại.

Ví dụ tốt:

> Gateway nhận bản tin trạng thái từ Zigbee adapter, chuẩn hóa dữ liệu theo device model, sau đó publish lên MQTT topic tương ứng để Cloud Backend lưu trạng thái mới nhất của thiết bị.

Ví dụ không tốt:

> Gateway xử lý rất tốt dữ liệu và giúp hệ thống chạy ổn định hơn.

Lý do sai: không có cơ chế, không có bằng chứng, không có phạm vi.

### 2.2. Không lạm dụng gạch đầu dòng

Không biến báo cáo thành checklist. Chỉ dùng bullet khi liệt kê:

- Yêu cầu hệ thống.
- Thành phần kiến trúc.
- Các bước test.
- Ưu/nhược điểm.
- Deliverable hoặc limitation.

Quy tắc thực tế:

| Trường hợp | Cách viết |
|---|---|
| Giải thích cơ chế hoạt động | Viết đoạn văn |
| So sánh lựa chọn kỹ thuật | Dùng bảng |
| Liệt kê yêu cầu hoặc test case | Dùng bullet/bảng |
| Trình bày data flow | Viết đoạn + hình |
| Nêu kết quả test | Dùng bảng + diễn giải sau bảng |

Không đặt quá nhiều cụm bullet liên tiếp. Sau mỗi bảng hoặc bullet quan trọng, phải có đoạn diễn giải ý nghĩa.

---

## 3. Quy tắc thuật ngữ tiếng Anh, viết tắt và acronym

### 3.1. Khi dùng thuật ngữ tiếng Anh lần đầu

Lần đầu tiên xuất hiện, phải giải thích sơ bộ trước hoặc ngay trong cùng câu.

Mẫu câu:

> Message Queuing Telemetry Transport (MQTT) là giao thức publish/subscribe dùng để trao đổi bản tin nhẹ giữa Gateway và Cloud. Trong hệ thống này, MQTT được dùng cho luồng trạng thái thiết bị và lệnh điều khiển.

Sau đó mới dùng `MQTT`.

### 3.2. Khi dùng acronym / viết tắt

Dùng mẫu:

> Tên đầy đủ tiếng Anh (Acronym) — giải thích tiếng Việt ngắn.

Ví dụ:

> Over-the-Air (OTA) — cơ chế cập nhật firmware từ xa cho thiết bị mà không cần nạp trực tiếp qua cáp.

Không dùng acronym nếu thuật ngữ chỉ xuất hiện 1–2 lần. Nếu đã dùng acronym, phải dùng nhất quán toàn báo cáo.

### 3.3. Danh mục từ viết tắt

Nếu báo cáo có nhiều hơn khoảng 10 acronym, phải có mục **Danh mục từ viết tắt** trước Chương 1.

Bảng đề xuất:

| Viết tắt | Tên đầy đủ | Giải thích ngắn | Xuất hiện chính ở chương |
|---|---|---|---|
| MQTT | Message Queuing Telemetry Transport | Giao thức publish/subscribe cho truyền thông Gateway–Cloud | Chương 2, 3, 4 |
| ZCL | Zigbee Cluster Library | Tập định nghĩa cluster/attribute/command của Zigbee | Chương 2, 3 |

### 3.4. Không trộn ngôn ngữ tùy tiện

Được giữ thuật ngữ kỹ thuật tiếng Anh khi đó là tên chuẩn: `Gateway`, `Cloud Backend`, `MQTT`, `REST API`, `Zigbee Cluster Library`, `Coordinator`, `Router`, `End Device`.

Nhưng không viết câu kiểu:

> Hệ thống sẽ sync status realtime và push command xuống device.

Cách viết đúng hơn:

> Hệ thống đồng bộ trạng thái thiết bị gần thời gian thực và gửi lệnh điều khiển xuống thiết bị thông qua Gateway.

---

## 4. Quy tắc cấu trúc đoạn văn

Mỗi mục lớn nên có cấu trúc:

1. **Mở mục**: mục này giải quyết vấn đề gì.
2. **Nội dung chính**: khái niệm, thiết kế, triển khai hoặc kết quả.
3. **Liên kết**: nội dung này dẫn sang phần tiếp theo như thế nào.

Mẫu đoạn kỹ thuật:

> Trong hệ thống đề tài, Gateway đóng vai trò trung gian giữa mạng Zigbee cục bộ và Cloud Backend. Ở phía thiết bị, Gateway nhận trạng thái từ Zigbee adapter thông qua boundary nội bộ của hệ thống. Ở phía Cloud, Gateway publish trạng thái thiết bị lên MQTT broker và subscribe các topic lệnh điều khiển. Cách tách này giúp hệ thống vẫn duy trì logic cục bộ khi Cloud tạm thời mất kết nối, đồng thời vẫn cho phép App giám sát trạng thái từ xa.

---

## 5. Quy tắc hình vẽ, sơ đồ, bảng và phương trình

### 5.1. Hình vẽ

Mỗi hình phải có 3 phần:

1. Đoạn giới thiệu trước hình.
2. Hình.
3. Chú thích và đoạn giải thích sau hình.

Caption của hình đặt **bên dưới hình**. Không để hình và caption tách sang hai trang khác nhau.

Mẫu:

> Hình 3.2 mô tả data flow từ thiết bị Zigbee lên Cloud Backend.

`[Hình 3.2 ở đây]`

> Hình 3.2 cho thấy Gateway là điểm chuyển đổi giữa dữ liệu thiết bị dạng local event và bản tin MQTT chuẩn hóa. Nhờ đó, Cloud không cần phụ thuộc trực tiếp vào chi tiết Zigbee bên dưới.

### 5.2. Bảng

Caption của bảng đặt **bên trên bảng**. Không dùng ảnh chụp bảng thay cho bảng thật.

Mỗi bảng phải có:

- Tên bảng rõ nghĩa.
- Tên cột đầy đủ.
- Đơn vị đo nếu có.
- Đoạn giải thích sau bảng.

Không dùng bảng nếu nội dung chỉ có 2–3 ý đơn giản.

### 5.3. Phương trình

Nếu có phương trình, phải:

- Đánh số phương trình.
- Giải thích từng biến.
- Ghi đơn vị đo.
- Chỉ dùng khi phương trình thật sự hỗ trợ lập luận.

Không đưa phương trình chỉ để “trông học thuật”.

---

## 6. Quy tắc citation và tài liệu tham khảo

### 6.1. Khi nào bắt buộc trích dẫn

Phải trích dẫn khi viết về:

| Nội dung | Ví dụ nguồn nên trích |
|---|---|
| Chuẩn kỹ thuật | Zigbee specification, IEEE 802.15.4, ZCL |
| Datasheet | EFR32MG12 datasheet, board manual |
| Công nghệ nền | MQTT, REST API, PostgreSQL, FastAPI |
| Hình/bảng lấy từ ngoài | Documentation, paper, datasheet |
| Số liệu, benchmark, thông số | Datasheet, test log, official docs |

Không cần trích dẫn cho kết quả tự test, nhưng phải có evidence như log, ảnh, bảng test.

### 6.2. Kiểu citation

Dùng kiểu IEEE numeric nếu trường/khoa không yêu cầu kiểu khác.

Ví dụ trong nội dung:

> Zigbee được thiết kế cho các mạng cá nhân không dây công suất thấp, phù hợp với các thiết bị cảm biến và điều khiển trong nhà thông minh [1].

Trong danh mục tài liệu tham khảo:

```text
[1] Connectivity Standards Alliance, "Zigbee Specification," version ..., year.
```

### 6.3. Không để nguồn “treo”

Nếu một nguồn xuất hiện trong References, nó phải được cite trong nội dung. Nếu cite trong nội dung, nó phải có trong References.

---

## 7. Quy tắc kết quả, test và evidence

Không được viết kết quả nếu chưa có bằng chứng.

Mỗi kết quả quan trọng cần ít nhất một trong các evidence sau:

| Loại kết quả | Evidence tối thiểu |
|---|---|
| Device join thành công | log Gateway/Zigbee, ảnh dashboard, mô tả thao tác |
| App điều khiển light | ảnh/video app, MQTT trace, command reply |
| Occupancy detect | log event, state change, test case |
| Rule automation | bảng input/expected/actual/result, log rule execution |
| Cloud sync | DB row/API response/MQTT message |
| Offline/reconnect | timeline log trước/sau mất mạng |

Nếu thiếu evidence, viết:

> TODO: Bổ sung evidence cho test case này, ví dụ log Gateway và ảnh dashboard sau khi chạy lại.

Không bịa `pass`, `latency`, `success rate`, số lần test, hoặc ảnh minh họa.

---

## 8. Quy tắc đặt nội dung đúng chương

| Nội dung | Đặt ở đâu | Không đặt ở đâu |
|---|---|---|
| “MQTT là gì?” | Chương 2 — Cơ sở lý thuyết | Chương 4 |
| “Topic MQTT của project là gì?” | Chương 3 — Thiết kế hệ thống | Chương 2 nếu chỉ mô tả chuẩn chung |
| “Code Gateway xử lý MQTT như thế nào?” | Chương 4 — Triển khai | Chương 2 |
| “Test app bật/tắt đèn thành công” | Chương 5 — Kiểm thử và đánh giá | Chương 3 |
| “Vì sao chọn Zigbee thay Wi-Fi/BLE?” | Chương 2 hoặc 3, tùy mức độ | Kết luận |
| “Hạn chế occupancy sensor chưa ổn định” | Chương 5 và nhắc lại ở Chương 6 | Không giấu trong phụ lục |
| “Hướng phát triển OTA, security, WebSocket” | Chương 6 | Không đưa thành kết quả đã làm |

---

## 9. Quy tắc cho báo cáo IoT Zigbee Smart Building

### 9.1. Luôn tách 3 lớp giải thích

Khi mô tả một tính năng, phải tách:

| Lớp | Câu hỏi cần trả lời |
|---|---|
| Device/Zigbee | Thiết bị nào phát sinh state/event/command? |
| Gateway | Gateway nhận, chuẩn hóa, quyết định hoặc forward dữ liệu ra sao? |
| Cloud/App | Cloud lưu gì, App hiển thị hoặc gửi command như thế nào? |

Ví dụ không đủ:

> Switch điều khiển light thông qua cloud.

Ví dụ đúng hơn:

> Khi người dùng nhấn Switch, Gateway nhận sự kiện từ mạng Zigbee, chuẩn hóa thành event của thiết bị switch và kiểm tra rule đang bật. Nếu rule hợp lệ, Gateway gửi lệnh On/Off tới Light, đồng thời publish event và trạng thái mới lên Cloud để App cập nhật giao diện.

### 9.2. Phải phân biệt “thiết kế” và “triển khai”

| Thiết kế | Triển khai |
|---|---|
| Architecture diagram | File/module cụ thể |
| Data flow | Hàm xử lý, service, topic |
| Contract | JSON payload, API endpoint |
| State model | Bảng enum, database schema |
| Test strategy | Test case và evidence |

Không trộn lẫn toàn bộ vào một mục.

### 9.3. Không dùng context lỗi thời

Nếu codebase hiện tại không còn dùng một cơ chế nào đó, không đưa vào báo cáo như kiến trúc chính.

Ví dụ: nếu project hiện tại dùng Z3Gateway-native và IPC/MQTT bridge, không mô tả custom UART `@DATA/@CMD/@ACK` như kiến trúc production, trừ khi ghi rõ đó là hướng cũ hoặc prototype ban đầu.

---

## 10. Quy tắc audit trước khi Agent viết

Trước khi viết hoặc sửa một chương, Agent phải tự kiểm tra:

| Câu hỏi audit | Đạt khi |
|---|---|
| Mục này thuộc chương nào? | Có lý do placement rõ ràng |
| Có thuật ngữ mới chưa giải thích không? | Thuật ngữ lần đầu có định nghĩa ngắn |
| Có viết tắt chưa mở rộng không? | Full term xuất hiện trước acronym |
| Có claim nào thiếu citation/evidence không? | Claim kỹ thuật có citation hoặc evidence |
| Có quá nhiều bullet không? | Có đoạn văn diễn giải sau bullet/bảng |
| Có hình/bảng nào chưa được giới thiệu không? | Có đoạn dẫn trước và giải thích sau |
| Có nội dung implementation nằm trong theory không? | Đã chuyển đúng chương |
| Có kết quả test bị bịa hoặc thiếu log không? | Thiếu thì ghi TODO, không giả định |

---

## 11. Checklist final trước khi nộp bản báo cáo

- [ ] Theo đúng template ĐATN/KLTN của trường/khoa.
- [ ] Có bìa, đề tài/nhiệm vụ, lời cảm ơn, tóm tắt, mục lục, danh mục hình, danh mục bảng.
- [ ] Có danh mục từ viết tắt nếu nhiều acronym.
- [ ] Mỗi chương có mở đầu và kết luận ngắn.
- [ ] Thuật ngữ tiếng Anh và viết tắt được giải thích ở lần đầu.
- [ ] Hình có caption bên dưới, bảng có caption bên trên.
- [ ] Tất cả hình/bảng/phương trình được nhắc trong nội dung.
- [ ] Không dùng ảnh chụp bảng.
- [ ] Không có bullet dày đặc thay cho phân tích.
- [ ] Kết quả test có evidence.
- [ ] Citation và References khớp nhau.
- [ ] Không có khoảng trắng trang lớn bất thường.
- [ ] Không có heading nằm cuối trang mà nội dung sang trang sau.
- [ ] Không có đoạn cuối trang chỉ còn một từ hoặc 1–2 dòng lẻ.
- [ ] Đơn vị có dấu cách với giá trị: `1 cm`, `5 mV`, `2 kg`.
- [ ] Không đưa tính năng chưa làm thành kết quả đã hoàn thành.

---

## 12. Nguồn tham khảo đã dùng để xây dựng rule

- File `Mẫu ĐATN_2023_version 1_1.md`: cấu trúc quyển, lời cảm ơn, tóm tắt, mục lục, danh mục hình/bảng, quy định trình bày.
- File `Các lưu ý khi viết báo cáo.md`: quy tắc text, hình, bảng, khoảng trắng, caption, citation, đơn vị.
- File `do-an.md`: ví dụ nhiệm vụ ĐATN, nội dung đề tài, lời cảm ơn, tóm tắt nội dung.
- HUST CTT: mẫu Đồ án/Khóa luận tốt nghiệp phiên bản 1.1.
- HUST SEEE: mẫu đồ án có hướng dẫn nội dung, format, phương trình, hình, bảng, trích dẫn, đóng quyển.
- Purdue OWL: hướng dẫn dùng bảng/hình/phương trình và quy tắc giới thiệu acronym/abbreviation.
