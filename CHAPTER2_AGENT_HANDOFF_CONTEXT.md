# Handoff context cho AI agent viết Chương 2

File này dùng để giao ngữ cảnh cho AI agent khác trước khi viết hoặc sửa Chương 2 của báo cáo ĐATN. Mục tiêu không phải là thay thế nội dung Chương 2, mà là giúp agent hiểu đúng dự án, chọn đúng lý thuyết cần trình bày, và tránh phóng đại các phần chưa triển khai.

## 1. Mục tiêu sử dụng

Agent đọc file này trước khi viết các mục thuộc Chương 2: Cơ sở lý thuyết và công nghệ nền. Sau khi đọc, agent cần biết:

- Dự án đang làm về hệ thống IoT Zigbee Smart Building.
- Kiến trúc hiện tại đi theo hướng Gateway C nói MQTT trực tiếp.
- Chương 2 chỉ trình bày nền tảng lý thuyết và công nghệ, không viết như kết quả triển khai.
- Những công nghệ có trong tên repo nhưng chưa phải runtime chính, ví dụ BLE, không được đưa thành trọng tâm.
- Những phần còn là roadmap, ví dụ OTA runtime hoàn chỉnh hoặc security hardening nâng cao, phải ghi đúng là nền tảng/hướng phát triển nếu cần nhắc tới.

## 2. Tóm tắt dự án hiện tại

Dự án là một nền tảng Smart Building mini dùng Zigbee để quản lý thiết bị trong phòng/lab. Người dùng thao tác trên mobile app; app gọi Cloud REST API; Cloud lưu dữ liệu và trao đổi lệnh qua MQTT; Gateway C nhận MQTT và chuyển thành Zigbee command qua EFR32 NCP; thiết bị Zigbee báo trạng thái ngược lại theo chiều ngược về Cloud và app.

Luồng tổng thể nên dùng làm mental model chính:

```text
Flutter Mobile App
  -> FastAPI Cloud REST API
  -> Mosquitto MQTT Broker
  -> Native Z3Gateway C Host App
  -> EFR32 NCP
  -> Zigbee End Devices
```

Không dùng kiến trúc Python MQTT-to-IPC bridge cũ làm mô hình chính. Trong repo hiện tại, Gateway là `Z3Gateway C` single-process và tích hợp MQTT trực tiếp.

## 3. Tech stack cần hiểu

| Lớp | Công nghệ hiện tại | Vai trò trong hệ thống | Bằng chứng nên đọc |
|---|---|---|---|
| Mobile App | Flutter, Dart, Provider, http | Giao diện người dùng, gọi API, hiển thị thiết bị/log/automation | `mobile_app/pubspec.yaml` |
| Cloud Backend | FastAPI, SQLAlchemy, Paho MQTT | REST API, lưu dữ liệu, publish/subscribe MQTT | `cloud/requirements.txt`, `cloud/app/` |
| Database | PostgreSQL trong production, SQLite cho test nếu có | Lưu devices, states, events, commands, automations | `database/`, `cloud/app/models.py`, `deploy/docker-compose.prod.yml` |
| MQTT Broker | Eclipse Mosquitto | Trung gian publish/subscribe giữa Cloud và Gateway | `mqtt/docker/docker-compose.yml`, `deploy/docker-compose.prod.yml` |
| Gateway | C, Silicon Labs Z3GatewayHost, libmosquitto | Nhận MQTT, route command, gọi Zigbee stack | `gateway/Z3GatewayHost/app/`, `Z3Gateway.Makefile` |
| Zigbee radio | EFR32 NCP qua UART/ASH/EZSP | Coordinator radio cho mạng Zigbee | `end_devices/ncp-uart-hw-fresh/`, `docs/FLASHING.md` |
| End devices | EmberZNet / Gecko SDK, C | Light, switch, occupancy sensor | `end_devices/Z3Light/`, `end_devices/Z3Switch/`, `end_devices/Z3_Occupancy_Sensor/` |
| Firmware artifacts | `.s37`, bootloader, flash bằng Simplicity Studio/Commander | Build/flash firmware cho board | `artifact/`, `docs/FIRMWARE_ARTIFACTS.md`, `docs/FLASHING.md` |

Lưu ý quan trọng: một số tài liệu cũ có thể nhắc Paho C hoặc Python gateway bridge. Khi viết báo cáo, ưu tiên source hiện tại và contract docs mới hơn. Gateway hiện tại có `app_mqtt.c` dùng `libmosquitto`.

## 4. Ranh giới Chương 2

Chương 2 là chương nền tảng. Khi viết, chỉ giải thích những khái niệm cần để người đọc hiểu thiết kế và triển khai ở Chương 3/4.

Nên viết:

- Khái niệm, vai trò, nguyên lý hoạt động.
- Vì sao công nghệ đó phù hợp với dự án.
- Trade-off ở mức ngắn gọn.
- Ví dụ gắn với flow thực tế của dự án.

Không nên viết:

- Chi tiết endpoint/API cụ thể như kết quả triển khai. Phần đó thuộc Chương 3/4.
- Log test, kết quả chạy, ảnh demo. Phần đó thuộc Chương 5.
- Tính năng chưa hoàn chỉnh như thể đã hoàn thành.
- Mô tả legacy Python bridge như kiến trúc chính.
- BLE như một lớp runtime chính nếu không có evidence trong source hiện tại.

## 5. Dàn ý lý thuyết khuyến nghị cho Chương 2

### 2.1. Tổng quan IoT và Smart Building

Viết sơ bộ rằng Internet of Things (IoT) là mô hình kết nối thiết bị vật lý với phần mềm để thu thập dữ liệu, giám sát và điều khiển. Trong Smart Building, các thiết bị như đèn, công tắc, cảm biến hiện diện và gateway phối hợp với Cloud/App để tự động hóa môi trường.

Nên liên hệ dự án:

- Thiết bị Zigbee báo trạng thái.
- Gateway chuyển dữ liệu lên Cloud.
- App hiển thị và gửi lệnh điều khiển.
- Automation rule giúp một sự kiện, ví dụ motion/switch, dẫn tới hành động điều khiển light.

Trade-off nên nhắc:

- Local network giúp độ trễ thấp hơn.
- Cloud giúp lưu trữ, giám sát và mở rộng.
- Phụ thuộc Cloud quá nhiều có thể làm hệ thống kém ổn định khi mất mạng.

### 2.2. Zigbee và IEEE 802.15.4

Giải thích Zigbee là giao thức truyền thông không dây công suất thấp, thường dùng cho mạng cảm biến và điều khiển trong nhà thông minh. IEEE 802.15.4 là nền tảng tầng vật lý và MAC mà Zigbee xây phía trên.

Nên có các ý:

- Zigbee phù hợp thiết bị IoT công suất thấp.
- Zigbee hỗ trợ mạng mesh.
- Zigbee có các vai trò Coordinator, Router, End Device.
- Dự án dùng EFR32/Silicon Labs/EmberZNet để triển khai mạng Zigbee.

Ví dụ dự án:

- EFR32 NCP đóng vai trò radio coordinator.
- Light/switch/occupancy sensor là end devices trong mạng Zigbee.

### 2.3. Vai trò thiết bị Zigbee

Nên giải thích ba role chính:

- Coordinator: tạo và quản lý mạng Zigbee.
- Router: chuyển tiếp gói tin và mở rộng vùng phủ.
- End Device: thiết bị cuối, thường tiết kiệm năng lượng, gửi/nhận dữ liệu ứng dụng.

Trong báo cáo, không cần đi quá sâu vào thuật toán routing. Chỉ cần đủ để hiểu vì sao Gateway cần coordinator radio và vì sao end devices có thể là light/switch/sensor.

### 2.4. Topology Zigbee

Nên trình bày Star, Tree và Mesh ở mức tổng quan. Với Smart Building, Mesh là điểm đáng chú ý vì cho phép nhiều thiết bị mở rộng vùng phủ và tăng độ linh hoạt.

Trade-off:

- Star đơn giản nhưng vùng phủ hạn chế.
- Mesh linh hoạt hơn nhưng phức tạp hơn về quản lý mạng và debug.

### 2.5. Zigbee Protocol Stack

Nên giải thích theo tầng:

- Physical/MAC: dựa trên IEEE 802.15.4.
- Network layer: địa chỉ, routing, network join.
- APS/Application Support: hỗ trợ binding, addressing ở tầng ứng dụng.
- Application/ZCL: mô hình cluster và command/attribute.

Không nên biến mục này thành tài liệu chuẩn Zigbee quá dài. Mục tiêu là giúp người đọc hiểu vì sao command bật/tắt đèn được biểu diễn bằng ZCL cluster thay vì chuỗi text tự do.

### 2.6. Zigbee Cluster Library (ZCL)

ZCL là phần rất quan trọng cho dự án. Nên giải thích rằng ZCL chuẩn hóa cách biểu diễn chức năng thiết bị qua cluster, attribute và command.

Ví dụ nên dùng:

- On/Off cluster `0x0006` cho bật/tắt đèn.
- Level Control cluster `0x0008` cho độ sáng.
- Occupancy Sensing cluster `0x0406` cho cảm biến hiện diện.

Liên hệ repo:

- `docs/DEVICE_CAPABILITY_MATRIX.md`
- `docs/ADAPTER_ACTION_MAP.md`
- `gateway/Z3GatewayHost/app/light_ctrl.c`
- `gateway/Z3GatewayHost/app/telemetry_rx.c`

### 2.7. Gateway trong hệ thống IoT

Gateway là cầu nối giữa mạng Zigbee local và Cloud. Trong dự án này, Gateway không chỉ forward dữ liệu, mà còn:

- Nhận MQTT command từ Cloud.
- Parse command.
- Route theo `device_type`.
- Gọi Zigbee action qua Ember AF/EZSP.
- Publish reported state/event/command reply ngược lên MQTT.
- Có rule engine cho local automation ở mức MVP.

Nên viết đúng ranh giới:

```text
Cloud/App <-> MQTT Broker <-> Z3Gateway C <-> EFR32 NCP <-> Zigbee devices
```

Không viết `@DATA/@CMD/@ACK` UART protocol như contract production hiện tại. Đây là legacy/debug context, không phải biên chính thức của runtime hiện tại.

### 2.8. MQTT và publish/subscribe

MQTT là giao thức messaging nhẹ theo mô hình publish/subscribe. Thành phần trung tâm là broker. Client không gửi trực tiếp cho nhau, mà publish vào topic và subscribe topic cần nhận.

Nên giải thích:

- Broker.
- Client.
- Topic.
- Payload.
- Publish.
- Subscribe.
- QoS.
- Retained message.
- Last Will and Testament nếu cần.

Liên hệ dự án:

- Cloud và Gateway cùng kết nối Mosquitto.
- Gateway publish reported state lên topic trạng thái.
- Cloud publish command request xuống Gateway.
- Reported state nên dùng retained message để subscriber mới có thể thấy trạng thái gần nhất.

Đọc thêm trong repo:

- `docs/MQTT_CONTRACT.md`
- `docs/ADAPTER_ACTION_MAP.md`
- `gateway/Z3GatewayHost/app/app_mqtt.c`
- `cloud/app/mqtt_client.py`

### 2.9. UART, ASH và EZSP giữa host và EFR32 NCP

Mục này cần viết cẩn thận. UART trong runtime hiện tại chủ yếu là đường serial giữa host Gateway và EFR32 NCP do Z3Gateway/EZSP/ASH quản lý. Không mô tả nó như application protocol chính của repo.

Nên giải thích:

- UART là giao tiếp nối tiếp giữa host và radio/NCP.
- NCP là Network Co-Processor, nghĩa là radio board xử lý phần Zigbee network/stack thấp hơn.
- EZSP/ASH là lớp giao tiếp Silicon Labs dùng giữa host app và NCP.
- Application contract chính của repo nằm ở MQTT và ZCL action mapping, không nằm ở custom UART frame.

### 2.10. REST API, Cloud Backend và Database

Nên giải thích Cloud Backend đóng vai trò:

- Cung cấp REST API cho mobile app.
- Lưu device registry, device state, event, command, automation.
- Kết nối MQTT để nhận trạng thái từ Gateway và gửi lệnh xuống Gateway.
- Theo dõi command lifecycle.

Công nghệ:

- FastAPI cho REST API.
- SQLAlchemy cho ORM.
- PostgreSQL cho production data.
- Paho MQTT cho Cloud MQTT client.

Không đi quá sâu vào từng endpoint trong Chương 2. Endpoint cụ thể nên để Chương 3/4.

### 2.11. Mobile App và state management

Nên viết mức nền tảng:

- Flutter là framework UI cross-platform.
- App gọi REST API qua HTTP.
- Provider quản lý trạng thái giao diện.
- App là lớp người dùng cuối để monitoring/control, không trực tiếp nói Zigbee.

Không viết chi tiết màn hình hoặc layout ở Chương 2, trừ khi chỉ nhắc vai trò tổng quan.

### 2.12. Firmware, bootloader và OTA

Phần này chỉ nên viết mức nền tảng hoặc hướng phát triển, tùy yêu cầu báo cáo.

Nên viết:

- Firmware là phần mềm chạy trên thiết bị nhúng.
- Artifact như `.s37` dùng để flash thiết bị trong quá trình phát triển.
- OTA là cơ chế cập nhật firmware qua mạng.
- Zigbee OTA thường cần OTA image, versioning, integrity check và OTA server/client behavior.

Cảnh báo:

- Không khẳng định Cloud/Gateway OTA runtime đã hoàn chỉnh nếu không có evidence.
- Theo docs hiện tại, Cloud chưa có OTA ORM/router hoàn chỉnh và Gateway chưa có MQTT OTA runtime project-owned hoàn chỉnh.
- Nếu nhắc OTA, ghi là planned contract/roadmap hoặc nền tảng công nghệ.

Đọc thêm:

- `docs/OTA_CAMPAIGN_CONTRACT.md`
- `docs/OTA_CONTRACT_AUDIT_20260521.md`
- `docs/FIRMWARE_ARTIFACTS.md`

### 2.13. Security trong Zigbee/IoT

Nên viết security ở mức cơ sở:

- Network key và application security trong Zigbee.
- Trust Center và quá trình join thiết bị.
- MQTT broker cần authentication/TLS trong môi trường production.
- Firmware signing giúp giảm rủi ro firmware giả mạo.

Cảnh báo:

- Không viết install-code TC join, APS encryption hardening, GBL signing hoặc MQTT mTLS như phần đã hoàn thiện nếu source không chứng minh.
- Có thể đưa vào phần nền tảng hoặc hướng phát triển.

## 6. Mapping lý thuyết với project evidence

| Lý thuyết | Vì sao cần trong Chương 2 | File/docs nên dùng làm evidence |
|---|---|---|
| IoT / Smart Building | Đặt bối cảnh bài toán monitoring/control/automation | `docs/FINAL_REPORT.md`, `CONTEXT.md` |
| Zigbee / IEEE 802.15.4 | Công nghệ mạng thiết bị chính | `end_devices/`, `docs/DEVICE_CAPABILITY_MATRIX.md` |
| Zigbee roles/topology | Giải thích coordinator/NCP/end devices | `docs/FLASHING.md`, `end_devices/ncp-uart-hw-fresh/` |
| ZCL | Giải thích cluster/attribute/command cho light/sensor | `docs/ADAPTER_ACTION_MAP.md`, `docs/DEVICE_CAPABILITY_MATRIX.md` |
| Gateway | Cầu nối Zigbee local và Cloud | `gateway/Z3GatewayHost/app/`, `docs/ADAPTER_ACTION_MAP.md` |
| MQTT | Contract Cloud/Gateway chính | `docs/MQTT_CONTRACT.md`, `gateway/Z3GatewayHost/app/app_mqtt.c`, `cloud/app/mqtt_client.py` |
| UART/EZSP/ASH | Host Gateway giao tiếp với EFR32 NCP | `docs/ADAPTER_ACTION_MAP.md`, `gateway/Z3GatewayHost/` |
| REST API / Backend | App giao tiếp Cloud, Cloud quản lý dữ liệu/lệnh | `cloud/app/`, `cloud/requirements.txt` |
| Database | Lưu state, event, command, automation | `cloud/app/models.py`, `database/`, `deploy/docker-compose.prod.yml` |
| Mobile App | Giao diện người dùng cuối | `mobile_app/pubspec.yaml`, `mobile_app/lib/` |
| OTA | Nền tảng/hướng phát triển firmware update | `docs/OTA_CAMPAIGN_CONTRACT.md`, `docs/OTA_CONTRACT_AUDIT_20260521.md` |
| Security | Nền tảng bảo mật IoT/Zigbee | `docs/FINAL_REPORT.md`, `docs/OTA_CAMPAIGN_CONTRACT.md` |

## 7. Những điều agent không được viết sai

1. Không nói BLE là phần chính của runtime hiện tại chỉ vì tên repo có BLE.
2. Không dùng Python MQTT-to-IPC bridge làm kiến trúc hiện tại.
3. Không nói `@DATA/@CMD/@ACK` là production contract hiện tại.
4. Không nói OTA end-to-end đã hoàn chỉnh nếu chưa có evidence mới.
5. Không nói security hardening nâng cao đã hoàn tất nếu chỉ nằm trong roadmap.
6. Không ghi kết quả kiểm thử nếu không có actual output.
7. Không biến Chương 2 thành Chương 4. Chương 2 là lý thuyết; code/file chỉ dùng để chọn đúng lý thuyết.
8. Không lạm dụng bullet trong bản báo cáo cuối. File handoff có thể bullet, nhưng khi viết LaTeX nên chuyển thành đoạn văn học thuật.

## 8. Cách viết cho người mới đọc vẫn hiểu

Khi viết Chương 2, mỗi khái niệm mới nên theo thứ tự:

1. Giải thích sơ bộ.
2. Thuật ngữ mới.
3. Cách hoạt động hoặc data flow.
4. Trade-off.
5. Ví dụ gắn với dự án.

Ví dụ với MQTT:

- Giải thích sơ bộ: MQTT là giao thức nhắn tin nhẹ cho IoT.
- Thuật ngữ: broker, client, topic, publish, subscribe.
- Data flow: Cloud publish command, Gateway subscribe và xử lý.
- Trade-off: nhẹ và phù hợp IoT, nhưng cần thiết kế topic/payload rõ.
- Ví dụ: command bật đèn đi từ app đến Cloud, qua MQTT đến Gateway.

## 9. Gợi ý prompt cho AI agent viết Chương 2

Prompt mẫu để viết toàn bộ Chương 2:

```text
Bạn là AI agent hỗ trợ viết báo cáo ĐATN tiếng Việt. Hãy đọc file CHAPTER2_AGENT_HANDOFF_CONTEXT.md, GLOBAL_REPORT_RULES_IOT_ZIGBEE.md và OUTLINE_GUIDE_IOT_ZIGBEE_THESIS.md trước.

Nhiệm vụ: viết/sửa Chương 2 - Cơ sở lý thuyết và công nghệ nền cho đề tài IoT Zigbee Smart Building.

Yêu cầu:
- Chỉ viết lý thuyết nền tảng, không trình bày như kết quả triển khai.
- Bám kiến trúc hiện tại: Flutter App -> FastAPI Cloud -> Mosquitto MQTT -> Z3Gateway C -> EFR32 NCP -> Zigbee End Devices.
- Không dùng Python bridge cũ làm kiến trúc chính.
- Không xem BLE là runtime chính nếu không có evidence.
- OTA và security nâng cao chỉ viết là nền tảng/hướng phát triển nếu chưa có evidence hoàn chỉnh.
- Viết văn phong học thuật kỹ thuật, mạch lạc, hạn chế bullet trong bản cuối.
- Mỗi mục cần có giải thích sơ bộ, thuật ngữ chính, cách hoạt động/data flow, trade-off và ví dụ liên hệ dự án.
```

Prompt mẫu để viết từng mục:

```text
Dựa trên CHAPTER2_AGENT_HANDOFF_CONTEXT.md, hãy viết mục [2.x TÊN MỤC] cho Chương 2.

Yêu cầu:
- Viết bằng tiếng Việt học thuật, dễ hiểu cho người mới ICT.
- Không đưa chi tiết triển khai quá sâu.
- Có liên hệ ngắn với dự án Zigbee Smart Building.
- Không khẳng định tính năng chưa hoàn chỉnh.
- Nếu cần nhắc file/source, chỉ dùng như evidence nội bộ, không biến thành phần triển khai.
```

## 10. Checklist trước khi agent xuất nội dung Chương 2

Trước khi trả nội dung cuối, agent phải tự kiểm tra:

- Nội dung có đúng là lý thuyết nền tảng không?
- Có lẫn kết quả triển khai/test sang Chương 2 không?
- Có nhầm legacy Python bridge với Gateway C hiện tại không?
- Có viết BLE là thành phần chính không?
- Có phóng đại OTA/security không?
- Có giải thích đủ các thuật ngữ mới không?
- Có liên hệ vừa đủ với dự án thật không?
- Có tránh bullet quá dày trong bản báo cáo cuối không?
- Có tuân thủ `GLOBAL_REPORT_RULES_IOT_ZIGBEE.md` và `OUTLINE_GUIDE_IOT_ZIGBEE_THESIS.md` không?

