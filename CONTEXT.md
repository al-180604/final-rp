# CONTEXT.md - Zigbee BLE Orchestration Platform

Cập nhật: 2026-05-21

File này là context nền để chuẩn bị viết báo cáo đồ án tốt nghiệp. Nội dung được tổng hợp từ repo thật tại `D:\CODE\zigbee-ble-orchestration-platform`, ưu tiên trạng thái source hiện tại hơn các tài liệu lịch sử.

## 0. Tóm tắt 1 phút

Dự án hiện tại là một nền tảng Smart Building mini dùng Zigbee để quản lý thiết bị trong nhà/phòng lab. Người dùng thao tác trên Flutter mobile app; app gọi Cloud REST API; Cloud lưu dữ liệu và publish command qua MQTT; Gateway C nhận MQTT, chuyển thành Zigbee command qua EFR32 NCP; Zigbee end devices báo trạng thái ngược lại về Gateway, MQTT, Cloud, rồi hiển thị lại trên app.

Luồng tổng thể:

```text
Flutter Mobile App
  -> FastAPI Cloud REST API
  -> Mosquitto MQTT Broker
  -> Native Z3Gateway C Host App
  -> EFR32 NCP
  -> Zigbee End Devices
```

Điểm cần nhấn mạnh trong báo cáo: kiến trúc hiện tại không còn dùng Python MQTT-to-IPC bridge cũ. Gateway hiện là `Z3Gateway C single-process` tích hợp MQTT trực tiếp.

Tên repo có `BLE`, nhưng qua source hiện tại chưa thấy module BLE chính thức trong runtime chính. Trọng tâm đồ án đang là Zigbee Smart Building.

## 1. Nguồn đã kiểm tra

Các file chính đã dùng làm bằng chứng:

- `README.md`: overview, module chính, tính năng MVP, lệnh run/deploy.
- `cloud/README.md`: Cloud stack, API, local run, deploy, environment variables.
- `cloud/app/main.py`: FastAPI app, routers, MQTT lifecycle, timeout worker.
- `cloud/app/models.py`: database models: Home, Room, User, Device, DeviceState, Event, Command, Automation.
- `cloud/app/routers/*.py`: API hiện có cho devices, commands, events, automations, gateways, health.
- `mobile_app/pubspec.yaml`: Flutter dependencies.
- `mobile_app/lib/`: UI features, repositories, view models.
- `gateway/Z3GatewayHost/app/`: native C gateway logic: MQTT, command handling, discovery, dispatch, network manager, light control.
- `mqtt/docker/docker-compose.yml`: local Mosquitto service.
- `deploy/docker-compose.prod.yml`: production services: Mosquitto, Postgres, Cloud API.
- `docs/MQTT_CONTRACT.md`: MQTT topic tree, envelope, QoS/retain, command lifecycle.
- `docs/DEVICE_CAPABILITY_MATRIX.md`: official v1 device types and capabilities.
- `docs/ADAPTER_ACTION_MAP.md`: MQTT to Z3Gateway C action mapping.
- `docs/OTA_CAMPAIGN_CONTRACT.md`: planned OTA contract.
- `docs/FLASHING.md` and `docs/FIRMWARE_ARTIFACTS.md`: firmware flashing and binary artifacts.
- `docs/iot_zigbee_sprint_plan.md`: historical roadmap; useful for future feature ideas, but some older architecture details are deprecated.

## 2. Giải thích sơ bộ theo hướng báo cáo

Đề tài có thể được mô tả là:

> Xây dựng nền tảng quản lý thiết bị Smart Building sử dụng Zigbee, gồm mobile app, cloud backend, MQTT broker, gateway native C và firmware cho thiết bị EFR32. Hệ thống hỗ trợ giám sát trạng thái thiết bị, điều khiển đèn từ xa, theo dõi command lifecycle, lưu event history và quản lý automation rule cơ bản. Nền tảng được thiết kế để có thể mở rộng lên OTA firmware update, MQTT over TLS, credential management, group/scene control và realtime push.

Nói ngắn gọn cho chương 1:

- Bài toán: quản lý thiết bị IoT nội bộ theo hướng đáng tin cậy, mở rộng được, có cloud và app.
- Giải pháp: dùng Zigbee cho local mesh network, MQTT cho message backbone, FastAPI cho cloud API, Flutter cho app.
- Giá trị kỹ thuật: có đủ data flow end-to-end từ mobile tới firmware và ngược lại.
- Giá trị thực tiễn: có thể áp dụng cho phòng lab, lớp học, nhà thông minh hoặc mô hình Smart Building nhỏ.

## 3. Thuật ngữ mới theo 3 mức độ

### 3.1 Tech Stack

Mức 5 tuổi:

Tech Stack giống như bộ đồ nghề để xây một ngôi nhà. Mỗi món đồ nghề làm một việc khác nhau.

Mức cấp 2:

Tech Stack là tập hợp ngôn ngữ, framework, database, tool và môi trường chạy mà dự án dùng để xây hệ thống.

Mức sinh viên năm nhất:

Tech Stack của dự án này gồm nhiều lớp: Flutter/Dart cho mobile, FastAPI/Python cho backend, PostgreSQL cho database, Mosquitto/MQTT cho message broker, C/Silicon Labs SDK cho gateway/firmware, Docker/PowerShell cho deploy.

Sau phần này, báo cáo có thể dùng thẳng từ `Tech Stack`.

### 3.2 Gateway

Mức 5 tuổi:

Gateway giống như người phiên dịch giữa app và thiết bị đèn/cảm biến.

Mức cấp 2:

Gateway là máy trung gian nhận lệnh từ Cloud qua MQTT, rồi chuyển lệnh đó sang Zigbee để thiết bị thật hiểu được.

Mức sinh viên năm nhất:

Trong dự án này, Gateway là native `Z3Gateway C host app`. Nó chạy trên Linux host, nói chuyện với MQTT broker, dùng EFR32 NCP làm Zigbee radio, xử lý command dispatch, device discovery, telemetry và local rule handling.

### 3.3 MQTT

Mức 5 tuổi:

MQTT giống như hộp thư. Ai có tin thì bỏ vào đúng hộp, ai cần thì lấy ra.

Mức cấp 2:

MQTT là giao thức publish/subscribe. Cloud, Gateway và các service không cần gọi trực tiếp nhau, mà gửi message qua broker.

Mức sinh viên năm nhất:

Trong dự án này, MQTT là message backbone giữa Cloud và Gateway. Topic tree dùng dạng `sb/v1/{tenant}/{site}/{gateway}/...`, mọi message dùng JSON envelope chung, command reply có lifecycle `accepted -> queued -> sent -> executed | failed | timeout`.

### 3.4 OTA

Mức 5 tuổi:

OTA giống như gửi bản cập nhật mới cho thiết bị mà không cần cắm dây.

Mức cấp 2:

OTA là cơ chế cập nhật firmware từ xa. Cloud gửi thông tin bản firmware, Gateway tải file, kiểm tra checksum, rồi đưa bản cập nhật cho thiết bị Zigbee.

Mức sinh viên năm nhất:

Theo `docs/OTA_CAMPAIGN_CONTRACT.md`, OTA trong dự án được thiết kế theo hướng metadata-over-MQTT, binary-over-HTTP: Cloud publish campaign manifest và desired state qua MQTT; Gateway tải `.ota` artifact bằng HTTP, verify `sha256` và `size_bytes`, lưu vào `SB_OTA_DIR`, rồi dùng native Zigbee OTA behavior để offer firmware cho thiết bị.

### 3.5 Security

Mức 5 tuổi:

Security là khóa cửa để người lạ không tự ý điều khiển thiết bị.

Mức cấp 2:

Security trong IoT cần bảo vệ app, API, MQTT broker, Gateway, Zigbee network và firmware update.

Mức sinh viên năm nhất:

Trong dự án hiện tại, security đã có một số nền tảng: MQTT có username/password, Mosquitto ACL/config, Zigbee network dùng network creator security/permit join, Cloud config tách qua environment variables. Các phần nên làm tiếp là backend auth router, bearer token thực sự, MQTT over TLS, credential rotation, OTA artifact signing, audit log và production secret management.

## 4. Tech Stack hiện tại

| Lớp | Công nghệ | Bằng chứng trong repo | Vai trò |
|---|---|---|---|
| Mobile App | Flutter, Dart | `mobile_app/pubspec.yaml` | Giao diện người dùng, gọi REST API, hiển thị thiết bị/log/automation |
| Mobile State Management | Provider | `provider: ^6.1.5+1` | Quản lý view model, theme, locale, auth, device dashboard |
| Mobile HTTP | `http: ^1.6.0` | `mobile_app/pubspec.yaml` | Gọi Cloud REST API |
| Backend API | FastAPI 0.115.6 | `cloud/requirements.txt` | REST API cho app |
| Backend ORM | SQLAlchemy 2.0.36, asyncpg | `cloud/requirements.txt` | Kết nối PostgreSQL async |
| Database | PostgreSQL 16 | `deploy/docker-compose.prod.yml` | Lưu devices, states, events, commands, automations |
| MQTT Client | Paho MQTT 2.1.0 | `cloud/requirements.txt` | Cloud subscribe/publish MQTT |
| MQTT Broker | Eclipse Mosquitto 2.0 | `mqtt/docker/docker-compose.yml` | Broker cho Cloud/Gateway |
| Gateway | C, Silicon Labs Z3Gateway Host | `gateway/Z3GatewayHost/app/` | Chuyển MQTT command thành Zigbee action |
| Zigbee Radio | EFR32 NCP | `docs/FLASHING.md` | Coordinator radio qua UART/ASH/EZSP |
| Firmware | Silicon Labs Gecko SDK 4.5.0 | `docs/FIRMWARE_ARTIFACTS.md` | Build/flash NCP, Z3Light, Z3Switch |
| Local/Prod Runtime | Docker Compose | `mqtt/docker/docker-compose.yml`, `deploy/docker-compose.prod.yml` | Chạy Mosquitto, Postgres, Cloud API |
| Backend Test | pytest | `cloud/tests/pytest.ini`, `cloud/tests/*.py` | Unit/integration tests cho Cloud |
| Mobile Test | flutter_test | `mobile_app/test/*.dart` | Widget/view model/repository tests |

## 5. Cấu trúc thư mục nên đưa vào báo cáo

| Thư mục | Ý nghĩa |
|---|---|
| `mobile_app/` | Flutter app để monitor device, điều khiển light và quản lý automation rule |
| `cloud/` | FastAPI backend, MQTT client, command tracking, events và automation API |
| `gateway/` | Native Z3Gateway C host app, xử lý MQTT, Zigbee command dispatch, telemetry và local rule |
| `mqtt/` | Mosquitto config, ACL, password files, local broker compose |
| `database/` | PostgreSQL schema |
| `deploy/` | EC2 deployment scripts và production Docker Compose |
| `end_devices/` | Silicon Labs end-device firmware projects |
| `artifact/` | Firmware binaries và manifest để flash board |
| `docs/` | Contracts, design notes, implementation plans, user guide |

## 6. Tính năng hiện có

### 6.1 Device monitoring

App có thể hiển thị danh sách thiết bị và trạng thái thiết bị qua Cloud API.

API liên quan:

- `GET /api/devices/`
- `GET /api/devices/{device_id}`
- `GET /api/devices/{device_id}/state`

Database liên quan:

- `Device`
- `DeviceState`
- `Event`

Theo capability matrix v1, device types chính thức là:

- `light`
- `switch`
- `motion`

Các trạng thái chính:

- `light`: `power`, `level`, `reachable`
- `switch`: `reachable`, optional `battery`
- `motion`: `occupancy`, `reachable`, optional `battery`

### 6.2 Light control

Người dùng có thể gửi lệnh bật/tắt đèn từ app.

Downlink flow:

```text
Mobile App
  -> POST /api/devices/{device_id}/command
  -> Cloud tạo Command
  -> Cloud publish MQTT commands/{command_id}/request
  -> Z3Gateway C nhận MQTT
  -> resolve device_id thành nodeId/endpoint
  -> gửi Zigbee On/Off command qua EFR32 NCP
  -> thiết bị light thực thi
```

Gateway code liên quan:

- `gateway/Z3GatewayHost/app/app_mqtt.c`
- `gateway/Z3GatewayHost/app/cmd_handler.c`
- `gateway/Z3GatewayHost/app/device_dispatch.c`
- `gateway/Z3GatewayHost/app/light_ctrl.c`

### 6.3 Command lifecycle

MQTT contract định nghĩa command reply lifecycle:

```text
accepted -> queued -> sent -> executed | failed | timeout
```

Ý nghĩa khi viết báo cáo:

- Không chỉ gửi lệnh một chiều.
- Hệ thống có cơ chế quan sát trạng thái lệnh.
- Cloud có thể hiển thị command pending/success/failure/timeout cho app.

API liên quan:

- `GET /api/commands/{command_id}`

Backend code liên quan:

- `cloud/app/routers/commands.py`
- `cloud/app/command_timeout.py`
- `cloud/tests/test_commands.py`
- `cloud/tests/test_timeout.py`

### 6.4 Event history

Cloud lưu event để app xem lịch sử.

API:

- `GET /api/events/`

Event có thể đến từ:

- device state report,
- gateway lifecycle event,
- automation/device events,
- permit join events.

### 6.5 Automation rule management

Automation hiện đã có cả Cloud API và Flutter UI.

Cloud API:

- `GET /api/automations`
- `GET /api/automations/{automation_id}`
- `POST /api/automations`
- `PUT /api/automations/{automation_id}`
- `POST /api/automations/{automation_id}/enable`
- `POST /api/automations/{automation_id}/disable`
- `DELETE /api/automations/{automation_id}`

Database model:

- `Automation`
- fields quan trọng: `name`, `enabled`, `tenant_id`, `site_id`, `gateway_id`, `version`, `trigger`, `actions`, `sync_status`, `last_run_status`, `last_error`

Mobile UI liên quan:

- `mobile_app/lib/ui/features/automation/views/automation_rules_view.dart`
- `mobile_app/lib/ui/features/automation/view_models/automation_view_model.dart`
- `mobile_app/lib/ui/features/automation/widgets/*`

Ý nghĩa trong báo cáo:

- Người dùng có thể tạo rule kiểu "when this happens, do that".
- Cloud lưu và đồng bộ rule.
- Gateway execution là trách nhiệm device-side/gateway-side.
- Đây là nền tảng để mở rộng local automation sau này.

### 6.6 Gateway commissioning và device rediscovery

Gateway API hỗ trợ mở/đóng mạng Zigbee để join thiết bị và rediscover thiết bị.

API:

- `POST /api/gateways/{gateway_id}/commissioning/open`
- `POST /api/gateways/{gateway_id}/commissioning/close`
- `POST /api/devices/{device_id}/rediscover`

Gateway code liên quan:

- `gateway/Z3GatewayHost/app/net_mgr.c`
- `gateway/Z3GatewayHost/app/device_discovery.c`
- `gateway/Z3GatewayHost/app/device_registry.c`

Trong `net_mgr.c`, Gateway dùng Silicon Labs network creator security để mở/đóng permit join và publish event như `permit_join_opened`, `permit_join_closed`, `permit_join_failed`.

### 6.7 Firmware artifacts và flashing

Repo có tài liệu firmware rõ:

- `artifact/bootloader-uart-xmodem/`
- `artifact/ncp-uart-hw/`
- `artifact/Z3Switch/`
- `artifact/Z3Light/`

Theo `docs/FIRMWARE_ARTIFACTS.md`:

- Bootloader binary: ready
- NCP binary: ready
- Z3Switch binary: not built
- Z3Light binary: not built

Lệnh flash mẫu:

```bash
commander flash artifact/ncp-uart-hw/ncp-uart-hw.s37 --device EFR32MG12P332F1024GL125
```

## 7. Data flow nên vẽ trong báo cáo

### 7.1 Downlink: app điều khiển thiết bị

```text
User tap "On" in Flutter App
  -> RemoteDeviceRepository gọi Cloud REST API
  -> FastAPI tạo Command trong DB
  -> MQTTService publish command request
  -> Mosquitto broker route message
  -> Z3Gateway C subscribe topic
  -> cmd_handler parse payload
  -> device_dispatch resolve target
  -> light_ctrl gửi Zigbee command
  -> Light node đổi trạng thái
```

### 7.2 Uplink: thiết bị báo trạng thái

```text
Zigbee device reports attribute
  -> EFR32 NCP nhận Zigbee frame
  -> Z3Gateway C callback xử lý report
  -> Gateway publish devices/{type}/{id}/reported
  -> Mosquitto broker route message
  -> Cloud MQTT client subscribe
  -> Cloud upsert DeviceState/Event
  -> Mobile App polling REST API
  -> UI hiển thị trạng thái mới
```

### 7.3 Automation flow

```text
User creates rule in Flutter App
  -> POST /api/automations
  -> Cloud validates trigger/actions
  -> Cloud stores Automation row
  -> Cloud publishes automation rule to MQTT
  -> Gateway receives synced rule
  -> Gateway/device-side logic executes when trigger occurs
  -> Cloud/App observe sync_status, last_run_status, event history
```

### 7.4 OTA planned flow

```text
Cloud creates OTA campaign manifest
  -> MQTT manifest topic
  -> Z3Gateway C downloads .ota artifact via HTTP
  -> Gateway verifies sha256 and size_bytes
  -> Gateway stores artifact under SB_OTA_DIR
  -> Cloud sends desired action stage_and_offer
  -> Gateway offers firmware through Zigbee OTA
  -> Gateway publishes progress/event topics
```

Quan trọng: firmware binary không đi qua MQTT; MQTT chỉ mang metadata/control/progress.

## 8. API hiện tại

| Nhóm | Method | Endpoint | Vai trò |
|---|---:|---|---|
| Health | GET | `/health` | Kiểm tra Cloud API sống |
| Devices | GET | `/api/devices/` | Lấy danh sách thiết bị |
| Devices | GET | `/api/devices/{device_id}` | Lấy chi tiết thiết bị |
| Devices | GET | `/api/devices/{device_id}/state` | Lấy state mới nhất |
| Commands | POST | `/api/devices/{device_id}/command` | Gửi lệnh điều khiển thiết bị |
| Commands | GET | `/api/commands/{command_id}` | Kiểm tra trạng thái command |
| Events | GET | `/api/events/` | Lấy lịch sử event |
| Automations | GET | `/api/automations` | Lấy danh sách rule |
| Automations | POST | `/api/automations` | Tạo rule |
| Automations | PUT | `/api/automations/{automation_id}` | Sửa rule |
| Automations | POST | `/api/automations/{automation_id}/enable` | Bật rule |
| Automations | POST | `/api/automations/{automation_id}/disable` | Tắt rule |
| Automations | DELETE | `/api/automations/{automation_id}` | Xóa rule |
| Gateways | POST | `/api/gateways/{gateway_id}/commissioning/open` | Mở permit join |
| Gateways | POST | `/api/gateways/{gateway_id}/commissioning/close` | Đóng permit join |
| Gateways | POST | `/api/devices/{device_id}/rediscover` | Rediscover thiết bị |

Lưu ý: mobile có `RemoteAuthRepository` gọi `/auth/login` và `/auth/logout`, nhưng source có TODO nói Cloud backend chưa expose auth router. Vì vậy auth nên đưa vào phần "sắp làm", không mô tả như tính năng hoàn chỉnh.

## 9. Database context

Các entity chính:

| Entity | Bảng | Ý nghĩa |
|---|---|---|
| `Home` | `homes` | Nhà/khu vực quản lý |
| `Room` | `rooms` | Phòng thuộc home |
| `User` | `users` | Người dùng, hiện có username và home_id |
| `Device` | `devices` | Thiết bị logic như `light-01`, có `device_type`, `eui64`, `room_id`, online status |
| `DeviceState` | `device_states` | State JSON được báo cáo từ thiết bị |
| `Event` | `events` | Lịch sử sự kiện |
| `Command` | `commands` | Lệnh điều khiển và status |
| `Automation` | `automations` | Rule automation, trigger/actions JSON, sync/run status |

Điểm hay để viết báo cáo: database không cố hard-code mọi state thành nhiều cột, mà dùng JSON cho `state`, `payload`, `target`, `trigger`, `actions`. Cách này giúp dễ mở rộng device/capability nhưng cần contract rõ để tránh dữ liệu lộn xộn.

## 10. MQTT contract context

Envelope chung:

```json
{
  "schema": "sb.v1",
  "msg_id": "...",
  "ts": 1773990000000,
  "tenant_id": "hust",
  "site_id": "lab01",
  "gateway_id": "gw-ubuntu-01",
  "source": "gateway",
  "trace_id": "trace-01",
  "correlation_id": "cmd_01",
  "payload": {}
}
```

Required fields:

- `schema`
- `msg_id`
- `ts`
- `tenant_id`
- `site_id`
- `gateway_id`
- `source`
- `payload`

Optional fields:

- `trace_id`
- `correlation_id`

Topic groups quan trọng:

- `gateway/health`
- `gateway/log`
- `gateway/event`
- `devices/{device_type}/{device_id}/registry`
- `devices/{device_type}/{device_id}/reported`
- `devices/{device_type}/{device_id}/desired`
- `devices/{device_type}/{device_id}/telemetry`
- `devices/{device_type}/{device_id}/event`
- `commands/{command_id}/request`
- `commands/{command_id}/reply`
- `ota/campaigns/{campaign_id}/manifest`
- `ota/devices/{device_id}/desired`
- `ota/devices/{device_id}/progress`
- `ota/devices/{device_id}/event`

Retain/QoS ý nghĩa:

- State/latest snapshot nên retain để consumer mới vào vẫn thấy trạng thái gần nhất.
- Telemetry tần suất cao không nhất thiết retain.
- Command reply không retain.
- Command lifecycle giúp debug được lệnh đang ở bước nào.

## 11. Kiểm thử hiện có

### 11.1 Backend tests

Cloud có pytest tests:

- `cloud/tests/test_automations.py`
- `cloud/tests/test_automation_e2e.py`
- `cloud/tests/test_commands.py`
- `cloud/tests/test_devices.py`
- `cloud/tests/test_gateways.py`
- `cloud/tests/test_mqtt_client.py`
- `cloud/tests/test_mqtt_gateway_events.py`
- `cloud/tests/test_schemas.py`
- `cloud/tests/test_timeout.py`

Lệnh chạy:

```powershell
pytest cloud/tests -q
```

Hoặc theo `cloud/README.md`:

```powershell
pytest cloud/tests/ -v
```

Ý nghĩa khi viết báo cáo:

- Có unit/integration coverage cho API, schemas, MQTT client, timeout worker, gateway events và automation.
- Test dùng sqlite in-memory cho nhiều case nên không nhất thiết cần Postgres/MQTT thật.
- Smoke test cần Postgres + Mosquitto + API chạy.

### 11.2 Mobile tests

Mobile có Flutter tests:

- `mobile_app/test/auth_gate_bypass_test.dart`
- `mobile_app/test/auth_view_model_test.dart`
- `mobile_app/test/automation_view_model_test.dart`
- `mobile_app/test/login_view_test.dart`
- `mobile_app/test/mobile_error_handling_test.dart`
- `mobile_app/test/remote_auth_repository_test.dart`
- `mobile_app/test/remote_automation_repository_test.dart`
- `mobile_app/test/remote_device_repository_test.dart`
- `mobile_app/test/widget_test.dart`

Lệnh chạy:

```powershell
cd mobile_app
flutter test
```

### 11.3 Manual/E2E checks nên mô tả

Các kịch bản nên đưa vào báo cáo kiểm thử:

1. Start Mosquitto local.
2. Start Cloud API.
3. Seed sample data.
4. Mở mobile app với API thật.
5. Xem danh sách devices.
6. Gửi light on/off command.
7. Kiểm tra command status.
8. Kiểm tra event history.
9. Tạo automation rule.
10. Enable/disable/delete automation rule.
11. Mở permit join và kiểm tra gateway event.
12. Flash firmware bằng Commander nếu có hardware.

## 12. Cách build/run local

### 12.1 Start MQTT broker

```powershell
cd D:\CODE\zigbee-ble-orchestration-platform\mqtt\docker
docker compose up -d
```

Mosquitto local expose:

- MQTT: `1883`
- WebSocket: `9001`

### 12.2 Run Cloud API

```powershell
cd D:\CODE\zigbee-ble-orchestration-platform
pip install -r cloud\requirements.txt
python -m cloud.app.seed
python -m cloud
```

Cloud API default:

- `http://localhost:8000`
- health check: `http://localhost:8000/health`

### 12.3 Run Flutter app

```powershell
cd D:\CODE\zigbee-ble-orchestration-platform\mobile_app
flutter run --dart-define=USE_MOCK_API=false --dart-define=API_BASE_URL=http://localhost:8000
```

Nếu chạy Android emulator và API nằm trên host machine:

```powershell
flutter run --dart-define=USE_MOCK_API=false --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

### 12.4 Deploy production

Theo README:

```powershell
Copy-Item deploy\.env.deploy.example deploy\.env.deploy
powershell -ExecutionPolicy Bypass -File deploy\deploy.ps1
```

Production compose có:

- `sb-mosquitto`
- `sb-postgres`
- `sb-cloud-api`

Ports:

- API: `8000`
- MQTT: `1883`
- MQTT WebSocket: `9001`
- PostgreSQL: `5432`

## 13. Các tính năng sắp làm / roadmap

Phần này nên viết rõ là "planned/future work", không viết như đã hoàn thành.

### 13.1 OTA firmware update

Nguồn: `docs/OTA_CAMPAIGN_CONTRACT.md`, `docs/MQTT_CONTRACT.md`, `docs/FIRMWARE_ARTIFACTS.md`.

Trạng thái hiện tại:

- Đã có contract OTA.
- Đã có topic design cho manifest, desired, progress, event.
- Đã có firmware artifact structure.
- Chưa nên mô tả OTA như feature production đã chạy end-to-end nếu chưa có implementation/test xác nhận.

Nội dung nên viết:

- Cloud tạo OTA campaign.
- Gateway nhận manifest qua MQTT.
- Gateway tải `.ota` qua HTTP.
- Gateway verify `sha256` và `size_bytes`.
- Gateway stage artifact vào `SB_OTA_DIR`.
- Gateway offer firmware qua Zigbee OTA.
- Gateway publish progress/event.

Trade-off:

- Ưu điểm: không gửi binary qua MQTT, giảm tải broker, dễ retry/download.
- Nhược điểm: cần HTTP artifact storage, checksum/signature, rollback và version compatibility.

### 13.2 Security hardening

Nguồn: `cloud/app/config.py`, `mqtt/docker/docker-compose.yml`, `gateway/Z3GatewayHost/app/net_mgr.c`, `docs/iot_zigbee_sprint_plan.md`.

Đã có nền:

- MQTT username/password.
- Mosquitto ACL/config.
- Zigbee network creator security và permit join window.
- Environment variables cho Cloud config.

Nên làm tiếp:

- Backend auth router thật cho `/auth/login` và `/auth/logout`.
- Bearer token/JWT hoặc session token cho mobile requests.
- MQTT over TLS, port production có thể tiến tới `8883`.
- Credential management: không hard-code password trong source.
- Secret rotation.
- Audit log cho command, automation, login.
- OTA artifact signing, không chỉ checksum.

Trade-off:

- Tăng bảo mật nhưng tăng độ phức tạp triển khai.
- TLS và auth cần quản lý certificate/token.
- Với đồ án, nên ưu tiên mô tả threat model đơn giản trước rồi mới mở rộng.

### 13.3 Realtime push

Hiện app có thể dùng polling REST API. Roadmap lịch sử nhắc WebSocket real-time push.

Hướng làm:

- Cloud push event/state update qua WebSocket.
- Mobile subscribe socket để giảm polling.

Trade-off:

- UX nhanh hơn.
- Backend phức tạp hơn, cần reconnect, heartbeat, auth cho socket.

### 13.4 Groups và Scenes

Theo device capability matrix, groups/scenes nằm ngoài v1.

Hướng làm:

- Groups: điều khiển nhiều đèn cùng lúc.
- Scenes: lưu preset ánh sáng, ví dụ "Presentation", "Night", "Meeting".

Trade-off:

- Phù hợp Smart Building thực tế hơn.
- Cần design lại capability, UI, MQTT topic và gateway dispatch.

### 13.5 Capability mở rộng

Ngoài v1, docs đề cập:

- light color,
- color temperature,
- transition time,
- motion illuminance,
- temperature.

Trade-off:

- Làm demo phong phú hơn.
- Cần firmware, contract, cloud schema và UI cùng thay đổi.

### 13.6 Raspberry Pi deployment

Roadmap lịch sử có gateway migration từ Linux laptop sang Raspberry Pi.

Hướng làm:

- Chạy Z3Gateway C host app trên Raspberry Pi.
- Kết nối EFR32 NCP qua USB/UART.
- Tự động start service bằng systemd.

Trade-off:

- Gần môi trường production hơn.
- Cần xử lý system service, device path, reboot recovery và log rotation.

## 14. Những điểm cần tránh viết sai trong báo cáo

1. Không viết rằng hệ thống hiện dùng Python MQTT-to-IPC bridge. Kiến trúc hiện tại đã chuyển sang native Z3Gateway C direct MQTT integration.
2. Không viết BLE là phần runtime chính nếu chưa có module BLE rõ ràng trong source.
3. Không viết OTA đã hoàn thành end-to-end nếu chưa có test/implementation xác nhận.
4. Không viết auth đã hoàn chỉnh: mobile có repository cho auth, nhưng Cloud backend chưa expose auth router.
5. Không viết `occ` hoặc `occupancy` là official device_type. Official v1 device_type là `motion`; `occupancy` là state value.
6. Không hứa groups/scenes/lock/unknown là v1 capability. Chúng đang là deferred/future.
7. Không đưa private key, `.pem`, password thật hoặc secret vào báo cáo.

## 15. Gợi ý bố cục chương báo cáo

### Chương 1 - Tổng quan đề tài

- Bối cảnh Smart Home/Smart Building.
- Vấn đề cần giải quyết.
- Mục tiêu đề tài.
- Phạm vi: Zigbee local network, Cloud API, MQTT, Gateway, Flutter app.
- Kết quả mong đợi.

### Chương 2 - Cơ sở lý thuyết

- Zigbee network.
- MQTT publish/subscribe.
- REST API.
- Gateway architecture.
- Cloud backend.
- Mobile app architecture.
- Firmware/OTA concept.
- Security trong IoT.

### Chương 3 - Phân tích và thiết kế hệ thống

- Use cases.
- System architecture diagram.
- Data flow downlink/uplink.
- Database design.
- MQTT contract.
- API design.
- Device capability matrix.

### Chương 4 - Triển khai hệ thống

- Cloud FastAPI.
- MQTT broker Mosquitto.
- Gateway C.
- Firmware artifacts/flashing.
- Flutter app.
- Automation rule management.
- Deploy local/EC2.

### Chương 5 - Kiểm thử và đánh giá

- Backend pytest.
- Flutter tests.
- Manual E2E test.
- Hardware flashing test.
- Command lifecycle test.
- Automation test.
- Đánh giá ưu điểm/hạn chế.

### Chương 6 - Kết luận và hướng phát triển

- Kết quả đạt được.
- Hạn chế hiện tại.
- Hướng phát triển: OTA, security hardening, WebSocket, groups/scenes, Raspberry Pi deployment.

## 16. Đoạn văn mẫu có thể đưa vào báo cáo

Đề tài xây dựng một nền tảng Smart Building mini sử dụng Zigbee làm mạng cục bộ để kết nối các thiết bị như đèn, công tắc và cảm biến chuyển động. Hệ thống được thiết kế theo kiến trúc nhiều lớp gồm Flutter mobile app, FastAPI cloud backend, Mosquitto MQTT broker, native Z3Gateway C host app và các thiết bị Zigbee chạy trên phần cứng EFR32. Người dùng có thể giám sát trạng thái thiết bị, gửi lệnh bật/tắt đèn từ xa, theo dõi vòng đời lệnh, xem lịch sử sự kiện và quản lý các automation rule cơ bản.

Điểm cốt lõi của hệ thống là Gateway đóng vai trò cầu nối giữa thế giới IP/cloud và mạng Zigbee local. Cloud backend không giao tiếp trực tiếp với thiết bị Zigbee mà publish command qua MQTT. Gateway subscribe các command này, ánh xạ `device_id` sang thông tin Zigbee như `nodeId` và `endpoint`, sau đó gửi lệnh tương ứng xuống thiết bị thông qua EFR32 NCP. Ở chiều ngược lại, trạng thái thiết bị được Gateway publish lên MQTT để Cloud lưu vào database và mobile app hiển thị cho người dùng.

Với cách tổ chức này, hệ thống có thể mở rộng theo nhiều hướng như OTA firmware update, MQTT over TLS, credential management, WebSocket realtime push, group control và scene control. Đây là nền tảng phù hợp cho một đồ án tốt nghiệp vì vừa thể hiện được kiến thức firmware/embedded, network protocol, backend, database, mobile app, deployment và kiểm thử end-to-end.

## 17. Checklist chuẩn bị báo cáo

- [ ] Vẽ architecture diagram theo luồng Mobile -> Cloud -> MQTT -> Gateway -> Zigbee.
- [ ] Vẽ sequence diagram cho light on/off command.
- [ ] Vẽ sequence diagram cho device reported state.
- [ ] Chụp màn hình mobile app: Home, Devices, Logs, Automation, Settings.
- [ ] Chụp kết quả `GET /health`.
- [ ] Chụp một request command và command status.
- [ ] Chụp database hoặc API response cho devices/events/automations.
- [ ] Chạy và lưu kết quả `pytest cloud/tests -q`.
- [ ] Chạy và lưu kết quả `flutter test`.
- [ ] Nếu có hardware, chụp quá trình flash bằng Simplicity Commander.
- [ ] Tách rõ phần đã làm và phần future work.

