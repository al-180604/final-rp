# OUTLINE GUIDE — Hướng dẫn đề mục báo cáo ĐATN IoT Zigbee Smart Building

> Mục đích: hướng dẫn AI Agent và sinh viên quyết định báo cáo nên có những đề mục nào, từng mục viết gì, và nội dung nên đặt ở chương nào.  
> Context: đồ án tốt nghiệp cử nhân về hệ thống IoT Zigbee Smart Building gồm thiết bị Zigbee, Gateway, Cloud Backend, API, App/Dashboard và rule automation.

---

## 0. Cấu trúc quyển theo template HUST

Thứ tự khuyến nghị khi đóng quyển:

1. Bìa trước.
2. Đề tài / nhiệm vụ tốt nghiệp có chữ ký theo quy định.
3. Lời cảm ơn và tóm tắt đồ án.
4. Mục lục.
5. Danh mục hình vẽ.
6. Danh mục bảng biểu.
7. Danh mục từ viết tắt, nếu có nhiều acronym.
8. Các chương nội dung chính.
9. Tài liệu tham khảo.
10. Phụ lục, nếu có.
11. Bìa cuối, nếu template yêu cầu.

Ghi chú: nếu template chính thức đặt `Phụ lục` trước `Tài liệu tham khảo` hoặc ngược lại, giữ theo template đang dùng.

---

## 1. Cấu trúc chương đề xuất

Với đề tài IoT/Zigbee có cả hardware, gateway, cloud và app, nên dùng cấu trúc 6 chương:

| Chương | Tên chương | Vai trò |
|---|---|---|
| Chương 1 | Tổng quan đề tài | Nêu vấn đề, mục tiêu, phạm vi, sản phẩm |
| Chương 2 | Cơ sở lý thuyết và công nghệ nền | Giải thích Zigbee, MQTT, Gateway, Cloud, App, lý do chọn |
| Chương 3 | Phân tích yêu cầu và thiết kế hệ thống | Kiến trúc, data flow, model, contract, rule |
| Chương 4 | Triển khai hệ thống | Mô tả phần cứng, firmware, gateway, backend, app |
| Chương 5 | Kiểm thử và đánh giá | Test case, kết quả, evidence, hạn chế |
| Chương 6 | Kết luận và hướng phát triển | Tổng kết đóng góp, phần chưa hoàn thiện, hướng mở rộng |

Cấu trúc này phù hợp hơn mẫu 3 chương nếu đề tài có nhiều module kỹ thuật. Mẫu 3 chương trong template có thể xem là mẫu trình bày, còn nội dung thực tế của đồ án kỹ thuật nên tách rõ theory/design/implementation/testing.

---

## 2. Phần trước Chương 1

### 2.1. Lời cảm ơn

Mục tiêu: cảm ơn ngắn gọn, trang trọng, không sáo rỗng.

Độ dài khuyến nghị: 100–150 từ.

Không nên viết quá dài hoặc đưa nội dung kỹ thuật vào đây. Không dùng các câu cảm tính quá mức như “vô cùng xuất sắc”, “hành trang cả đời”, nếu không cần thiết.

### 2.2. Tóm tắt nội dung đồ án

Độ dài tối đa khuyến nghị: khoảng 300 chữ.

Cấu trúc tóm tắt:

| Thành phần | Nội dung cần viết |
|---|---|
| Vấn đề | Vì sao cần hệ thống IoT/Zigbee Smart Building |
| Phương pháp | Thiết kế thiết bị, Gateway, Cloud, App, rule automation |
| Công cụ | EFR32, Zigbee stack, Gateway host, MQTT, FastAPI, database, Flutter/App |
| Kết quả | Những luồng đã chạy được, ví dụ join, state sync, command, automation |
| Tính thực tế | Ứng dụng cho giám sát/điều khiển thiết bị trong phòng/lab |
| Hướng phát triển | OTA, bảo mật, rule nâng cao, dashboard, độ ổn định |

Mẫu ngắn:

> Đồ án xây dựng một hệ thống IoT Smart Building sử dụng Zigbee cho mạng thiết bị cục bộ, Gateway làm lớp trung gian, Cloud Backend để lưu trữ và cung cấp API, và ứng dụng để giám sát/điều khiển thiết bị. Hệ thống tập trung vào các luồng chính gồm thiết bị tham gia mạng, đồng bộ trạng thái, gửi lệnh điều khiển, và rule automation giữa sensor, switch và light. Kết quả được đánh giá thông qua các test case end-to-end, log Gateway, MQTT trace và giao diện App/Dashboard.

### 2.3. Danh mục từ viết tắt

Nên có nếu báo cáo dùng nhiều thuật ngữ như MQTT, API, REST, OTA, ZCL, NCP, EUI64, DB, UI, QoS.

Bảng mẫu:

| Viết tắt | Tên đầy đủ | Giải thích |
|---|---|---|
| MQTT | Message Queuing Telemetry Transport | Giao thức publish/subscribe dùng cho truyền thông Gateway–Cloud |
| ZCL | Zigbee Cluster Library | Thư viện định nghĩa cluster, attribute và command của Zigbee |
| API | Application Programming Interface | Giao diện để các phần mềm giao tiếp với nhau |

---

# CHƯƠNG 1. TỔNG QUAN ĐỀ TÀI

## 1.1. Bối cảnh và lý do chọn đề tài

Nên viết:

- Nhu cầu điều khiển và giám sát thiết bị trong tòa nhà/phòng/lab.
- Vì sao cần mạng thiết bị tiết kiệm năng lượng.
- Vì sao cần Gateway và Cloud thay vì chỉ điều khiển cục bộ.
- Vấn đề thực tế: nhiều loại device, trạng thái không đồng bộ, rule automation cần linh hoạt.

Không nên viết quá sâu về Zigbee ở đây. Chương 1 chỉ nêu bối cảnh và vấn đề.

## 1.2. Mục tiêu của đồ án

Nên chia thành mục tiêu tổng quát và mục tiêu cụ thể.

Mẫu:

> Mục tiêu tổng quát của đồ án là thiết kế và triển khai một hệ thống IoT Smart Building có khả năng kết nối thiết bị Zigbee, đồng bộ trạng thái lên Cloud và cho phép điều khiển/automation thông qua Gateway.

Mục tiêu cụ thể nên gồm:

| Nhóm mục tiêu | Ví dụ |
|---|---|
| Thiết bị | Light, Switch, Occupancy Sensor có thể join mạng Zigbee |
| Gateway | Nhận state/event, gửi command, xử lý rule |
| Cloud | Lưu device/state/event/command, cung cấp REST API |
| App/Dashboard | Hiển thị trạng thái, gửi lệnh, xem rule/event |
| Kiểm thử | Có test case và evidence cho các luồng chính |

## 1.3. Phạm vi và giới hạn

Nên viết rõ cái gì làm, cái gì không làm.

Ví dụ:

| Trong phạm vi | Ngoài phạm vi hoặc chưa hoàn thiện |
|---|---|
| Join thiết bị Zigbee vào mạng demo | Sản phẩm thương mại hoàn chỉnh |
| Điều khiển light qua Gateway/Cloud/App | Bảo mật production đầy đủ |
| Rule switch/occupancy → light | Rule engine phức tạp như hệ nhà thông minh thương mại |
| Lưu state/event cơ bản | Big data analytics |
| Demo end-to-end trong lab | Triển khai diện rộng nhiều tầng/tòa nhà |

## 1.4. Phương pháp thực hiện

Nên trình bày theo logic:

1. Khảo sát công nghệ.
2. Thiết kế kiến trúc.
3. Triển khai từng module.
4. Tích hợp end-to-end.
5. Kiểm thử và đánh giá.

Không kể lịch sử làm việc quá chi tiết kiểu nhật ký từng ngày.

## 1.5. Đóng góp chính của đồ án

Nên viết thành đoạn văn hoặc bảng ngắn.

Ví dụ:

| Đóng góp | Ý nghĩa |
|---|---|
| Thiết kế kiến trúc Gateway–Cloud cho thiết bị Zigbee | Tách mạng local khỏi ứng dụng Cloud/App |
| Chuẩn hóa device state và command lifecycle | Giúp App/Dashboard hiển thị nhất quán |
| Rule automation cho switch/occupancy/light | Tạo hành vi thông minh có thể cấu hình |
| Bộ test case và evidence | Chứng minh hệ thống hoạt động theo yêu cầu |

## 1.6. Cấu trúc báo cáo

Viết ngắn: mỗi chương 1–2 câu.

---

# CHƯƠNG 2. CƠ SỞ LÝ THUYẾT VÀ CÔNG NGHỆ NỀN

Mục tiêu của chương này là giải thích nền tảng kỹ thuật để người đọc hiểu vì sao hệ thống được thiết kế như ở Chương 3.

## 2.1. Tổng quan IoT và Smart Building

Nên viết:

- IoT là gì trong phạm vi đề tài.
- Smart Building cần sensor, actuator, gateway, cloud, app.
- Luồng tổng quát: sensing → communication → processing → control → monitoring.

Không viết quá rộng về lịch sử IoT.

## 2.2. Zigbee trong hệ thống IoT

Nên giải thích:

| Mục | Nội dung |
|---|---|
| Zigbee là gì | Mạng không dây công suất thấp, phù hợp sensor/actuator |
| Device roles | Coordinator, Router, End Device |
| Network topology | Star/tree/mesh ở mức khái niệm |
| Ưu điểm | Tiết kiệm năng lượng, hỗ trợ nhiều thiết bị, mesh |
| Hạn chế | Băng thông thấp, cần Gateway, debug phức tạp hơn Wi-Fi |

## 2.3. Zigbee Cluster Library và mô hình thiết bị

Nên viết ở đây nếu báo cáo dùng Light/Switch/Occupancy.

Các khái niệm nên giải thích:

| Thuật ngữ | Viết gì |
|---|---|
| Cluster | Nhóm chức năng chuẩn của thiết bị |
| Attribute | Trạng thái hoặc thuộc tính trong cluster |
| Command | Lệnh gửi đến thiết bị |
| On/Off Cluster | Dùng cho light/switch |
| Occupancy Sensing Cluster | Dùng cho sensor phát hiện có người |

Không đưa code callback vào Chương 2. Code để Chương 4.

## 2.4. Gateway trong hệ thống IoT

Nên viết:

- Gateway là cầu nối giữa Zigbee local network và Cloud.
- Gateway chuyển đổi dữ liệu từ thiết bị thành format thống nhất.
- Gateway có thể xử lý local automation để giảm phụ thuộc vào Cloud.

Nếu project hiện tại dùng Z3Gateway-native + IPC/MQTT bridge, phải mô tả đúng boundary hiện tại. Không dùng lại mô tả prototype cũ nếu không còn áp dụng.

## 2.5. MQTT và cơ chế publish/subscribe

Nên viết:

- Message Queuing Telemetry Transport (MQTT) là gì.
- Publish/subscribe khác request/response như thế nào.
- Vì sao MQTT phù hợp telemetry và command.
- Khái niệm topic, QoS, retain, LWT nếu có dùng trong project.

Đặt ở Chương 2 phần khái niệm. Topic cụ thể của project đặt ở Chương 3.

## 2.6. REST API, Cloud Backend và Database

Nên viết:

| Thành phần | Nội dung |
|---|---|
| REST API | App gọi API để lấy device/state/event và gửi command |
| Cloud Backend | Nhận MQTT, lưu DB, cung cấp API |
| Database | Lưu device registry, state history, event, command |
| Trade-off | REST dễ triển khai nhưng real-time kém WebSocket/MQTT trực tiếp |

## 2.7. Công nghệ sử dụng

Nên trình bày thành bảng:

| Lớp | Công nghệ | Vai trò trong đồ án |
|---|---|---|
| Device | EFR32 / Zigbee stack | Thiết bị light/switch/occupancy |
| Gateway | Z3GatewayHost / adapter / bridge | Kết nối Zigbee với Cloud |
| Broker | Mosquitto MQTT | Trung gian publish/subscribe |
| Backend | FastAPI | REST API và MQTT subscriber |
| Database | PostgreSQL/SQLite | Lưu trạng thái và sự kiện |
| App | Flutter/Dashboard | Giao diện giám sát và điều khiển |

---

# CHƯƠNG 3. PHÂN TÍCH YÊU CẦU VÀ THIẾT KẾ HỆ THỐNG

Mục tiêu của chương này là trả lời: hệ thống cần làm gì và được thiết kế ra sao.

## 3.1. Yêu cầu chức năng

Nên chia theo actor hoặc module.

Bảng mẫu:

| ID | Yêu cầu | Mô tả | Mức ưu tiên |
|---|---|---|---|
| FR-01 | Quản lý thiết bị | Hệ thống ghi nhận thiết bị join mạng và hiển thị trên App/Dashboard | Must |
| FR-02 | Đồng bộ trạng thái | Light/Switch/Occupancy gửi state/event lên Cloud | Must |
| FR-03 | Điều khiển thiết bị | App gửi command bật/tắt light qua Cloud và Gateway | Must |
| FR-04 | Rule automation | Cho phép switch/occupancy điều khiển light theo rule | Must |
| FR-05 | Event log | Lưu và hiển thị lịch sử event/command | Should |

## 3.2. Yêu cầu phi chức năng

Nên có:

| Nhóm | Ví dụ yêu cầu |
|---|---|
| Độ trễ | Command round-trip dưới ngưỡng demo, ví dụ < 2 s nếu đã đo được |
| Tin cậy | Có ACK/reply hoặc trạng thái failed/timeout |
| Mở rộng | Thêm device type không phải sửa toàn bộ hệ thống |
| Bảo mật | Không hardcode credential, MQTT credential tách khỏi code |
| Quan sát hệ thống | Có log Gateway, MQTT trace, event log |

Không ghi số liệu nếu chưa đo. Nếu chưa đo, ghi là “mục tiêu thiết kế” hoặc “cần kiểm chứng”.

## 3.3. Kiến trúc tổng thể

Bắt buộc nên có hình architecture.

Nội dung cần viết:

- Device layer.
- Gateway layer.
- MQTT broker.
- Cloud backend.
- Database.
- App/Dashboard.

Sau hình phải giải thích data flow chính.

## 3.4. Data flow chính

Nên có ít nhất 3 flow:

### 3.4.1. Uplink: Device → Cloud/App

Mẫu:

```text
Zigbee Device → Gateway Adapter → MQTT Bridge → MQTT Broker → Cloud Backend → Database → App/Dashboard
```

Viết rõ mỗi bước biến đổi dữ liệu gì.

### 3.4.2. Downlink: App/Cloud → Device

Mẫu:

```text
App → REST API → Command Row → MQTT Request → Gateway → Zigbee Command → Device → Command Reply → Cloud/App
```

### 3.4.3. Local automation

Mẫu:

```text
Occupancy/Switch Event → Gateway Rule Engine → Light Command → State/Event Sync → Cloud/App
```

Giải thích vì sao local automation hữu ích: giảm phụ thuộc vào Internet/Cloud và giảm độ trễ.

## 3.5. Device model và state model

Nên có bảng:

| Device type | State chính | Event chính | Command chính |
|---|---|---|---|
| Light | on/off, reachable, level nếu có | state_changed, unreachable | on, off, toggle |
| Switch | pressed/released hoặc action | button_press | enable/disable nếu có |
| Occupancy | occupied/unoccupied, reachable | motion_detected, vacancy | configure/reporting nếu có |

## 3.6. Communication contract

Đây là nơi đặt topic MQTT, payload schema, command lifecycle, API endpoint.

Không giải thích “MQTT là gì” ở đây nữa. Chỉ trình bày contract của project.

Nên có:

- MQTT namespace.
- Topic tree.
- Envelope chung.
- Ví dụ payload reported state.
- Ví dụ command request/reply.
- Command lifecycle: accepted → queued → sent → executed/failed/timeout.
- REST API endpoints.

## 3.7. Thiết kế rule automation

Nên viết:

- Rule gồm trigger, condition, action, enabled/disabled.
- Rule phải có source device và target device.
- Rule switch→light và occupancy→light nên dùng cùng một mô hình để dễ enable/disable/remap.
- Nếu có nhiều light/sensor, rule phải hỗ trợ mapping linh hoạt.

Bảng mẫu:

| Rule | Trigger | Condition | Action | Ghi chú |
|---|---|---|---|---|
| R-01 | Occupancy event | occupied = true | light-01 on | Có thể disable |
| R-02 | Occupancy event | occupied = false trong X giây | light-01 off | Có timeout |
| R-03 | Switch press | action = toggle | light-01 toggle | Không dùng direct binding nếu cần rule management |

## 3.8. Thiết kế database và API

Nên đặt schema ở đây nếu báo cáo có backend.

Các bảng nên mô tả theo vai trò, không cần dump toàn bộ SQL nếu quá dài. SQL chi tiết để phụ lục.

| Bảng | Vai trò |
|---|---|
| devices | Lưu thông tin thiết bị |
| device_states | Lưu trạng thái báo cáo |
| events | Lưu event từ device/gateway |
| commands | Theo dõi vòng đời lệnh điều khiển |
| rules | Lưu rule automation nếu đã triển khai |
| rooms/users nếu có | Phân nhóm thiết bị và người dùng |

---

# CHƯƠNG 4. TRIỂN KHAI HỆ THỐNG

Mục tiêu của chương này là trả lời: thiết kế ở Chương 3 được hiện thực bằng module/file/service nào.

## 4.1. Môi trường phần cứng và phần mềm

Nên có bảng:

| Thành phần | Thông tin |
|---|---|
| Board | EFR32/WSTK/radio board cụ thể |
| Host | Ubuntu PC/Raspberry Pi nếu có |
| Broker | Mosquitto, port, môi trường chạy |
| Backend | FastAPI, Python version |
| Database | PostgreSQL/SQLite |
| App | Flutter/Dashboard |
| Tool | Simplicity Studio, Commander, Git |

## 4.2. Triển khai thiết bị Zigbee

Tách theo thiết bị:

### 4.2.1. Light node

Viết:

- Vai trò trong mạng.
- Cluster dùng.
- State/command hỗ trợ.
- Cách test cơ bản.

### 4.2.2. Switch node

Viết:

- Button event.
- Cách event được đưa về Gateway.
- Nếu bỏ direct binding, giải thích chuyển sang rule-based control.

### 4.2.3. Occupancy sensor

Viết:

- Cách phát hiện occupied/unoccupied.
- Timeout/debounce nếu có.
- Vấn đề hiện tại nếu sensor chưa detect ổn định.

## 4.3. Triển khai Gateway

Nên tách:

| Mục | Nội dung |
|---|---|
| Adapter boundary | Gateway nhận/gửi dữ liệu với Zigbee layer như thế nào |
| MQTT bridge | Publish reported/event, subscribe desired/command |
| Command handler | Xử lý command request và reply |
| Rule engine | Xử lý automation local |
| Logging | Log nào được tạo để debug và test |
| Error handling | Timeout, failed, unsupported trigger, device unreachable |

## 4.4. Triển khai Cloud Backend

Nên viết:

- Cấu trúc service.
- API chính.
- MQTT subscriber/publisher.
- Database schema.
- Cách lưu command status.
- Cách App lấy dữ liệu.

Không đưa quá nhiều code. Nếu cần code, chỉ đưa snippet nhỏ minh họa logic quan trọng.

## 4.5. Triển khai App/Dashboard

Nên viết:

- Màn hình chính.
- Device card.
- Command flow từ UI.
- Rule management screen nếu có.
- Event log/debug view nếu có.

Giao diện chỉ là một phần. Cần liên hệ UI với API/data flow.

## 4.6. Deployment và cấu hình

Nên viết:

- EC2/docker/systemd/nginx nếu có.
- ENV/config.
- Cách chạy Gateway.
- Cách kiểm tra broker/API.
- Không để lộ credential thật.

---

# CHƯƠNG 5. KIỂM THỬ VÀ ĐÁNH GIÁ

Mục tiêu của chương này là chứng minh hệ thống hoạt động, không chỉ mô tả đã làm.

## 5.1. Kế hoạch kiểm thử

Nên chia test theo flow:

| Nhóm test | Mục tiêu |
|---|---|
| Device join | Kiểm tra thiết bị tham gia mạng |
| Uplink | State/event lên Cloud/App |
| Downlink | App/Cloud điều khiển thiết bị |
| Automation | Rule switch/occupancy → light |
| Reliability | Reconnect, timeout, failed command |
| UI/API | API trả đúng dữ liệu, App hiển thị đúng |

## 5.2. Môi trường kiểm thử

Ghi rõ:

- Board nào.
- Gateway chạy ở đâu.
- Broker/Cloud ở đâu.
- App/Dashboard dùng version nào.
- Network/lab setup.
- Thời điểm test nếu cần.

## 5.3. Test case format bắt buộc

Dùng bảng test case theo format mentor yêu cầu:

| No | Name | Summary | Detail content | Input | Expected output | Actual output | Result | Evidence |
|---|---|---|---|---|---|---|---|---|
| TC-01 | Light command from App | Kiểm tra App bật/tắt light | Gửi command từ App qua REST API, Cloud publish MQTT, Gateway gửi lệnh tới light | Tap ON | Light ON, command executed, App cập nhật state | TODO | TODO | log/screenshot/video |

Không ghi `Pass` nếu chưa có actual output và evidence.

## 5.4. Test scenario nên có cho project

### 5.4.1. Device join

- Light join.
- Switch join.
- Occupancy join.
- Cloud/App hiển thị online đúng hay không.

### 5.4.2. Light control từ App/Dashboard

- App gửi ON/OFF.
- Cloud tạo command.
- Gateway nhận command.
- Light đổi trạng thái.
- App nhận trạng thái mới.

### 5.4.3. Switch điều khiển Light qua rule

- Switch event được Gateway nhận.
- Rule được tìm thấy và enabled.
- Light đổi trạng thái.
- Cloud/App được sync.

### 5.4.4. Occupancy điều khiển Light qua rule

- Occupancy phát hiện occupied/unoccupied.
- Gateway chạy rule.
- Light bật/tắt theo timeout.
- Nếu lỗi, ghi rõ lỗi và nguyên nhân nghi ngờ.

### 5.4.5. Error case

Nên có các case:

| Case | Ý nghĩa |
|---|---|
| unsupported_trigger | Rule không hỗ trợ trigger hiện tại |
| device offline | Command gửi tới device không reachable |
| timeout | Command không có reply đúng hạn |
| failed | Gateway/Cloud trả trạng thái lỗi |
| stale state | App/Dashboard hiển thị không khớp trạng thái thật |

## 5.5. Đánh giá kết quả

Không chỉ liệt kê test pass/fail. Phải phân tích:

- Hệ thống đã đáp ứng mục tiêu nào.
- Mục tiêu nào chưa đạt.
- Nguyên nhân kỹ thuật.
- Ảnh hưởng đến demo/bảo vệ.
- Hướng xử lý tiếp theo.

Bảng mẫu:

| Tiêu chí | Kết quả | Nhận xét |
|---|---|---|
| Uplink state sync | Đạt/chưa đạt | Dựa trên MQTT trace và App state |
| Downlink command | Đạt/chưa đạt | Dựa trên command reply và trạng thái thiết bị |
| Rule switch-light | Đạt/chưa đạt | Dựa trên event/rule log |
| Rule occupancy-light | Đạt/chưa đạt | Nếu sensor chưa detect, ghi rõ |
| App/Dashboard consistency | Đạt/chưa đạt | So sánh trạng thái thật và UI |

## 5.6. Hạn chế

Hạn chế phải trung thực.

Ví dụ:

> Occupancy sensor có thể join mạng và hiển thị online, nhưng chưa xác nhận được việc phát hiện chuyển động ổn định. Vì vậy, phần automation dựa trên occupancy cần được kiểm thử lại sau khi tháo/cắm lại board và thu log event từ Gateway.

Không viết hạn chế chung chung như “do thời gian có hạn”.

---

# CHƯƠNG 6. KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN

## 6.1. Kết luận

Tóm tắt theo mục tiêu đã đặt ở Chương 1.

Cấu trúc:

1. Đã xây dựng được gì.
2. Các luồng nào đã kiểm chứng.
3. Giá trị của hệ thống.
4. Phần còn hạn chế.

## 6.2. Kiến thức và kỹ năng đạt được

Có thể viết:

- Hiểu kiến trúc IoT nhiều lớp.
- Làm việc với Zigbee device/gateway.
- Thiết kế MQTT topic/payload.
- Xây dựng backend/API.
- Thiết kế test end-to-end và debug log.

Không viết quá cảm tính.

## 6.3. Hướng phát triển

Nên tách theo nhóm:

| Nhóm | Hướng phát triển |
|---|---|
| Device | Thêm sensor mới, ổn định occupancy, hỗ trợ group/scene |
| Gateway | Health monitoring, reconnect, local cache |
| Cloud | WebSocket/realtime push, rule management hoàn chỉnh |
| Security | TLS MQTT, credential management, secure join |
| OTA | Cập nhật firmware từ xa |
| App | Dashboard log, rule editor, UX tốt hơn |

---

# 7. Bảng quyết định nhanh: nội dung này đặt ở đâu?

| Nội dung muốn viết | Chương phù hợp | Lý do |
|---|---|---|
| Zigbee là gì | Chương 2 | Kiến thức nền |
| Zigbee Coordinator/Router/End Device | Chương 2 | Khái niệm chuẩn |
| Device cụ thể light/switch/occupancy trong project | Chương 3 hoặc 4 | Thiết kế model ở Ch3, triển khai ở Ch4 |
| MQTT là gì | Chương 2 | Công nghệ nền |
| MQTT topic `sb/v1/...` | Chương 3 | Contract thiết kế của project |
| API endpoint | Chương 3 | Thiết kế interface |
| Code FastAPI router | Chương 4 | Triển khai |
| Database schema | Chương 3 nếu thiết kế, Chương 4 nếu migration/implementation | Tùy mức chi tiết |
| Rule automation model | Chương 3 | Thiết kế logic |
| Rule execution log | Chương 5 | Evidence kiểm thử |
| Lỗi App không sync state | Chương 5 | Kết quả test/hạn chế |
| Giải pháp sửa lỗi | Chương 4 nếu đã triển khai, Chương 6 nếu là future work | Tránh ghi chưa làm thành đã làm |
| Hình architecture | Chương 3 | Thiết kế tổng thể |
| Screenshot UI | Chương 4 hoặc 5 | UI implementation hoặc evidence test |
| File tree/code structure | Chương 4 hoặc Phụ lục | Không nên làm loãng Chương 3 |
| Full JSON/MQTT contract dài | Phụ lục | Chương 3 chỉ đưa bản rút gọn |
| Full log dài | Phụ lục | Chương 5 chỉ trích phần quan trọng |

---

# 8. Phụ lục nên có

Phụ lục chỉ chứa thông tin hỗ trợ, không dùng để giấu nội dung chính.

Gợi ý phụ lục:

| Phụ lục | Nội dung |
|---|---|
| Phụ lục A | MQTT topic và payload đầy đủ |
| Phụ lục B | REST API endpoint chi tiết |
| Phụ lục C | Test log/MQTT trace rút gọn |
| Phụ lục D | Hướng dẫn build/run Gateway/Cloud/App |
| Phụ lục E | Hình ảnh demo hoặc cấu hình board |
| Phụ lục F | Danh sách test case đầy đủ nếu quá dài |

---

# 9. Template viết cho từng mục

Khi Agent viết một mục bất kỳ, dùng khung sau:

```text
[Mở đầu]
Mục này trình bày ... nhằm ...

[Giải thích / thiết kế / triển khai]
Nội dung chính gồm ...
Đối với hệ thống này, ...

[Liên hệ hình/bảng nếu có]
Hình/Bảng X mô tả ...

[Phân tích]
Điểm quan trọng của thiết kế này là ...
Trade-off của lựa chọn này là ...

[Kết luận mục]
Như vậy, phần này làm rõ ... và là cơ sở cho phần tiếp theo ...
```

---

# 10. Checklist cho Agent khi viết OUTLINE

- [ ] Đề mục không trùng ý giữa các chương.
- [ ] Chương 2 chỉ giải thích nền tảng, không sa vào code.
- [ ] Chương 3 tập trung thiết kế, không dump implementation.
- [ ] Chương 4 mô tả triển khai có module/file/service cụ thể.
- [ ] Chương 5 có test case, actual output và evidence.
- [ ] Chương 6 không đưa tính năng chưa làm thành kết quả.
- [ ] Mọi acronym đều được mở rộng lần đầu.
- [ ] Hình/bảng/phương trình đều được giới thiệu và diễn giải.
- [ ] Nếu thiếu dữ liệu test, ghi TODO thay vì bịa.
