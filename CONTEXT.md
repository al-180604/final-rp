Được. Mình sẽ viết phần **context dự án** theo kiểu bạn có thể lấy gần như nguyên văn để đưa vào **Chương 1 – Tổng quan đề tài** và làm khung cho toàn bộ báo cáo.

Mình sẽ không viết theo kiểu lý thuyết chung chung, mà theo đúng **scope hiện tại của đồ án**:
**smart home / smart building mini-platform** gồm **Zigbee local network**, **gateway trên Linux rồi chuyển sang Raspberry Pi**, **cloud**, **mobile app Flutter**, và có hướng mở rộng **OTA**.

---

# 1) Context tổng quát của dự án

## 1.1 Bối cảnh bài toán

Trong các hệ thống **smart home** và **smart building**, nhu cầu không chỉ là gắn thêm vài thiết bị thông minh, mà là xây được một hệ thống có thể:

* kết nối nhiều **node** không dây trong nhà,
* giám sát trạng thái thiết bị theo thời gian thực,
* điều khiển thiết bị từ xa qua app,
* chạy một phần **automation** ngay tại local để không phụ thuộc hoàn toàn vào Internet,
* và có khả năng mở rộng sau này như **OTA**, **scene**, **event log**, **health monitoring**.

Bài toán cốt lõi của dự án này không phải chỉ là “bật tắt đèn”, mà là xây một kiến trúc **end-to-end** hoàn chỉnh:
**device → coordinator → gateway → cloud → mobile app → command quay ngược về device**.

Đây là loại bài toán rất phù hợp để làm đồ án tốt nghiệp vì nó chạm vào cả:

* **embedded firmware**
* **wireless network**
* **gateway software**
* **cloud integration**
* **mobile app**
* **system design**

---

# 2) Vì sao dự án chọn Zigbee làm local network

## 2.1 Bối cảnh công nghệ

Trong nhà thông minh, lớp local network cần một giao thức có các đặc điểm:

* tiêu thụ điện năng thấp,
* phù hợp cho cảm biến chạy pin,
* hỗ trợ nhiều node,
* hỗ trợ **mesh network** để mở rộng vùng phủ,
* có mô hình thiết bị chuẩn như light, switch, sensor,
* có hệ sinh thái công nghiệp đủ mạnh để làm project nghiêm túc.

Zigbee phù hợp với kiểu bài toán này vì nó được thiết kế cho hệ thống nhiều thiết bị truyền dữ liệu nhỏ, có hỗ trợ **mesh** và phù hợp với các use case như smart home, smart building và automation phân tán.

## 2.2 Ý nghĩa của việc chọn Zigbee trong đồ án

Việc chọn Zigbee giúp dự án có giá trị kỹ thuật ở 3 mức:

### Mức 1 — Thiết bị

Node có thể là:

* **light**
* **switch**
* **occupancy sensor**
* sau này có thể thêm **lock**, **curtain**, **temperature sensor**

### Mức 2 — Mạng

Hệ thống không còn là point-to-point đơn giản, mà là một **Zigbee network** với:

* **Coordinator**
* **Router**
* **End Device**

### Mức 3 — Hệ thống

Zigbee không đứng một mình, mà là local layer trong kiến trúc lớn hơn có **gateway**, **MQTT/HTTP**, **cloud** và **mobile app**.

---

# 3) Context của phần Zigbee local network

## 3.1 Vai trò của Zigbee network trong dự án

Phần **local network** là nền tảng vật lý và logic gần thiết bị nhất. Đây là nơi diễn ra:

* đo đạc trạng thái từ sensor,
* truyền lệnh điều khiển tới actuator,
* liên kết giữa switch và light,
* event sensing như occupied / unoccupied,
* và khả năng fallback local khi cloud bị mất kết nối.

Nói đơn giản:
**đây là lớp “hệ thần kinh tại chỗ” của ngôi nhà thông minh.**

## 3.2 Các loại node chính trong dự án

### Light node

Đây là **actuator** chính của dự án.
Nó nhận lệnh **On/Off** từ network và đổi trạng thái đèn thật hoặc module điều khiển đèn.

### Switch node

Đây là **input device** cục bộ.
Vai trò của nó là gửi lệnh điều khiển light ngay trong local network, không cần cloud.

### Occupancy sensor node

Đây là **sensor node** để nhận biết có người / không có người trong khu vực.
Trong Zigbee chuẩn, bài toán này bám theo **Occupancy Sensing cluster** với cluster ID **0x0406**, dùng để cấu hình và báo trạng thái occupancy.

Nếu cảm biến dùng PIR, Zigbee ZCL còn có sẵn các thuộc tính như:

* `PIROccupiedToUnoccupiedDelay`
* `PIRUnoccupiedToOccupiedDelay`
* `PIRUnoccupiedToOccupiedThreshold`
  để chỉnh độ trễ và ngưỡng chuyển trạng thái occupied/unoccupied.

## 3.3 Vai trò các loại thiết bị trong mạng Zigbee

Trong dự án này, cần hiểu rõ 3 vai trò:

### Coordinator

* tạo mạng Zigbee,
* chọn PAN,
* cho thiết bị join,
* quản lý bảo mật như **Trust Center**,
* và làm đầu mối giao tiếp ra ngoài hệ thống.
  Trong thực tế, một mạng Zigbee chỉ có **một Coordinator**.

### Router

* mở rộng vùng phủ,
* chuyển tiếp gói tin,
* phù hợp với node luôn có nguồn như light module.

### End Device

* là các node cuối như sensor/switch,
* không định tuyến,
* có thể ngủ để tiết kiệm pin,
* phù hợp với cảm biến dùng pin.

## 3.4 Binding, endpoint, cluster trong context dự án

Đây là phần rất nên viết vào báo cáo vì nó thể hiện bạn hiểu Zigbee ở mức hệ thống chứ không chỉ nạp firmware mẫu.

### Endpoint

Mỗi thiết bị có thể có nhiều **endpoint**, mỗi endpoint đại diện cho một chức năng ứng dụng.

### Cluster

Mỗi endpoint có thể chứa nhiều **cluster**, ví dụ:

* **On/Off cluster** cho light
* **Occupancy Sensing cluster** cho motion/PIR
* sau này có thể thêm **Level Control**, **Electrical Measurement**, v.v.

### Binding

**Binding** là liên kết logic giữa thiết bị nguồn và thiết bị đích.
Ví dụ: switch endpoint 1 cluster On/Off được bind tới light endpoint 1 cluster On/Off.
Sau khi bind, switch có thể gửi lệnh đến light theo quan hệ logic thay vì phải hardcode địa chỉ tĩnh.

Trong context dự án, binding rất quan trọng vì:

* nó giảm phụ thuộc vào địa chỉ mạng thay đổi,
* phù hợp cho local control,
* và là cơ chế “smart home đúng chất Zigbee”, không phải tự chế toàn bộ từ đầu.

---

# 4) Context của phần Gateway

## 4.1 Vì sao cần Gateway

Zigbee không phải giao thức IP, nên các node Zigbee không thể trực tiếp nói chuyện với Internet hay mobile app.
Vì vậy cần một **gateway** để đóng vai trò **bridge** giữa thế giới Zigbee và thế giới IP/cloud.
Gateway chính là lớp “biên dịch” giữa:

* Zigbee frames / ZCL commands
* và MQTT / HTTP / app commands.

## 4.2 Kiến trúc Gateway trong dự án này

Dự án của bạn đang đi theo hướng rất hợp lý:

### Phase 1

* **Linux laptop** làm gateway host

### Phase 2

* chuyển sang **Raspberry Pi**

### Zigbee side

* dùng **EFR32MG12** ở vai trò radio/coordinator/NCP

### Host side

* chạy **gateway application**
* nhận dữ liệu từ Zigbee side
* bridge lên cloud
* nhận command từ app/cloud và gửi xuống node

Đây đúng với mô hình **NCP (Network Co-Processor)**:

* radio board xử lý phần Zigbee stack,
* host xử lý application logic, cloud integration và extensibility.
  Mô hình này thường dùng **EZSP** giữa NCP và host, và **Z3Gateway** của Silicon Labs là một ví dụ host app chạy trên Linux với giao diện MQTT.

## 4.3 Vai trò thực tế của Gateway trong đồ án

Trong dự án này, gateway không chỉ là “cầu nối truyền dữ liệu”.
Nó còn là nơi hợp lý nhất để đặt:

* **device registry**
* **state normalization**
* **rule engine**
* **event log**
* **health monitoring**
* **offline fallback logic**
* **OTA coordination**

### Ví dụ

Khi cảm biến occupancy báo `occupied`, gateway có thể:

1. nhận event,
2. chạy rule,
3. gửi lệnh bật light,
4. ghi log,
5. đồng bộ state lên cloud,
6. để app thấy trạng thái mới.

Nghĩa là gateway là **trục xương sống** của toàn bộ hệ.

---

# 5) Context của UART bridge và interface contracts

## 5.1 Vì sao UART bridge quan trọng

Trong dự án, giữa **Coordinator/NCP** và **Gateway host** cần một lớp giao tiếp ổn định, dễ debug, dễ log.
Bạn đang đi theo hướng dùng **UART/USB serial**, đây là hướng rất thực tế cho lab và cho giai đoạn prototype.

## 5.2 Ý nghĩa của UART contract

Một đồ án kiểu này rất dễ fail nếu không chốt sớm **contract** giữa firmware và gateway.

Project mẫu bạn đang bám có pattern rõ:

* `@DATA`
* `@CMD`
* `@ACK`
* frame format: `@PREFIX {JSON}\r\n`
* UART `115200 8N1 CRLF`

Về mặt kỹ thuật, ý nghĩa là:

* `@DATA`: node/coordinator gửi telemetry hoặc state đi lên
* `@CMD`: gateway gửi lệnh điều khiển đi xuống
* `@ACK`: coordinator trả kết quả thực thi lệnh

Đây là điểm rất đáng viết trong báo cáo vì nó cho thấy bạn không chỉ làm thiết bị, mà còn biết **interface design**.

## 5.3 Vì sao contract phải freeze sớm

Nếu `UART contract`, `MQTT topics`, `state enums` thay đổi liên tục:

* firmware và gateway sẽ lệch nhau,
* dashboard/app hiển thị sai,
* integration sẽ rất tốn thời gian debug.

Đây là lý do trong planning nội bộ, team cần freeze contract từ sớm rồi mới mở rộng payload theo node mới.

---

# 6) Context của MQTT / cloud layer

## 6.1 Vai trò của cloud layer

Cloud trong dự án này không nên được hiểu đơn thuần là “nơi lưu dữ liệu”.
Nó có 4 vai trò chính:

* đồng bộ **current state**
* lưu **event history**
* làm nơi nhận/gửi **command** từ app
* hỗ trợ mở rộng như **notification**, **OTA campaign**, **analytics**

## 6.2 Vai trò của MQTT

MQTT rất phù hợp ở lớp gateway–cloud vì:

* nhẹ,
* hỗ trợ **pub/sub**,
* tách producer và consumer,
* hợp với telemetry và command kiểu IoT.

Trong kiến trúc hiện tại, gateway publish state/telemetry lên broker và subscribe command topic để nhận lệnh điều khiển.
Trong sample report, topic pattern kiểu:

* `.../state`
* `.../telemetry`
* `.../cmd/...`
* `.../ack`
* `.../status/gateway`
  đã thể hiện đúng mô hình này.

## 6.3 Context cloud riêng cho dự án của bạn

Với scope hiện tại, phần cloud nên được mô tả như sau:

### Chức năng nền

* user/device/home/room organization
* command dispatch
* state synchronization
* event persistence

### Chức năng nâng cao

* OTA campaign management
* dashboard analytics
* notification
* device health / audit

Nếu bạn dùng **Firebase**, thì trong báo cáo nên mô tả cloud như một lớp:

* lưu **desired state**
* lưu **reported state**
* lưu **history**
* làm backend cho mobile app

Không nhất thiết phải mô tả Firebase quá chi tiết ở chương context; phần đó nên để sang chương thiết kế.

---

# 7) Context của mobile app

## 7.1 Vai trò của mobile app trong hệ thống

Mobile app không phải là nơi xử lý logic mạng Zigbee.
Vai trò đúng của app là:

* giao diện cho người dùng cuối,
* quan sát trạng thái thiết bị theo thời gian thực,
* gửi command điều khiển,
* cấu hình rule / scene / mode,
* nhận thông báo và xem event log.

## 7.2 Ý nghĩa khi chọn Flutter

Chọn **Flutter** giúp dự án có tính thực dụng cao vì:

* nhanh dựng MVP,
* UI tốt,
* dễ demo,
* dễ nối cloud/backend.

Trong bối cảnh đồ án, app là lớp chứng minh rằng hệ thống không chỉ chạy ở mức firmware, mà đã trở thành một **user-facing system**.

## 7.3 App nên được mô tả như gì trong báo cáo

Bạn nên mô tả app như **presentation layer** của hệ thống, với 3 màn hình cốt lõi:

* **device list / room view**
* **device detail + control**
* **event/history/health**

Như vậy báo cáo sẽ rõ vai trò kiến trúc hơn là chỉ kể “có app để bấm nút”.

---

# 8) Context của OTA

## 8.1 Vì sao OTA là phần quan trọng

Một hệ thống smart home thực tế không dừng ở việc chạy firmware bản đầu tiên.
Khi số lượng thiết bị tăng, việc cập nhật thủ công từng node sẽ rất khó vận hành.
Vì vậy **OTA (Over-The-Air update)** là một hướng mở rộng có giá trị thực tế rất cao.

Trong Zigbee, OTA thường do **coordinator/gateway** đóng vai trò **OTA Server**, lưu file `.ota` và phân phối cho các thiết bị khi client yêu cầu.

## 8.2 Context OTA trong dự án này

Với đồ án của bạn, OTA nên được mô tả theo hướng:

### Cloud

* quản lý campaign
* quyết định thiết bị nào cần update
* cấp metadata/version/artifact

### Gateway

* lưu image OTA tại local
* serve image cho Zigbee nodes
* theo dõi tiến độ update

### Device

* check version
* tải block
* verify
* reboot vào bootloader
* chạy firmware mới

Zigbee OTA client/server có flow chuẩn gồm:

* query image,
* image block transfer,
* upgrade end,
* apply image,
* rejoin network sau update.

## 8.3 Ý nghĩa của OTA trong báo cáo

Ngay cả khi phiên bản hiện tại chưa hoàn thiện OTA full, bạn vẫn nên để nó trong **context và hướng phát triển**, vì điều đó cho thấy kiến trúc của bạn đã được thiết kế để **scale** và **bảo trì được trong thực tế**.

---

# 9) Context của security

## 9.1 Vì sao security phải có trong context

Với smart home, nếu chỉ nói điều khiển đèn/cảm biến mà không nhắc đến **security**, báo cáo sẽ bị thiếu chiều sâu hệ thống.

## 9.2 Những điểm security nên nhắc

### Local Zigbee side

* **Trust Center**
* **Network Key**
* **Link Key**
* join policy
* bảo mật khi thiết bị tham gia mạng

Trong Zigbee centralized security, Coordinator thường đóng vai trò **Trust Center**, chịu trách nhiệm quản lý khóa và kiểm soát thiết bị được gia nhập mạng hay không.

### Cloud side

* authentication
* authorization
* secure transport
* không hardcode secrets

### Gateway side

* lưu config/secrets an toàn
* kiểm soát reconnect
* tránh gửi command trùng lặp
* log sự kiện quan trọng

Ở chương context, chỉ cần nói đủ để người đọc hiểu rằng đây không phải một demo “bật đèn cho vui”, mà là một hệ có ý thức về vận hành thật.

---

# 10) Context của data flow

Đây là phần rất đáng viết vì nó là xương sống logic.

## 10.1 Uplink flow

Luồng dữ liệu đi lên:

**occupancy/light state → coordinator/NCP → gateway → MQTT/cloud → app**

Ý nghĩa:

* lấy trạng thái thật từ local network
* chuẩn hóa và đồng bộ lên lớp cloud
* app nhìn thấy theo thời gian thực

## 10.2 Downlink flow

Luồng điều khiển đi xuống:

**app → cloud → gateway → coordinator/NCP → light**

Ý nghĩa:

* command xuất phát từ user
* gateway translate và dispatch
* device thực thi
* kết quả quay ngược về bằng **ACK/state report**

Project mẫu đã mô tả rất rõ command path:
dashboard publish command → gateway subscribe → gateway tạo `@CMD` → coordinator gửi Zigbee command → device thực thi → coordinator tạo `@ACK` → gateway publish lại để dashboard biết thành công/thất bại.

## 10.3 Ý nghĩa học thuật

Phần này cho phép bạn phân tích trong báo cáo:

* latency
* reliability
* retry/timeout
* consistency giữa UI và trạng thái thật
* trade-off giữa local automation và cloud control

---

# 11) Context về phạm vi và ràng buộc của đồ án

Đây là phần rất quan trọng, vì nếu không viết rõ phạm vi thì hội đồng dễ hỏi theo hướng “sao chưa có cái này, sao chưa có cái kia”.

## 11.1 Phạm vi nên chốt

Phiên bản hiện tại tập trung vào:

* local network Zigbee cho **light / switch / occupancy**
* gateway trên **Linux laptop**
* cloud integration
* app Flutter để monitor/control
* end-to-end command và state flow
* hướng mở rộng OTA

## 11.2 Những gì không nên hứa quá sớm

Bạn nên ghi rõ các phần **không phải trọng tâm của phiên bản hiện tại**, ví dụ:

* tối ưu pin chuyên sâu
* đánh giá năng lượng dài hạn
* commercial-grade security hardening
* large-scale deployment
* interoperability với mọi hãng third-party
* AI/predictive control

Trong sample report trước đó, phần “ràng buộc và phạm vi” cũng tách rõ những gì chỉ mô phỏng chức năng để kiểm chứng kiến trúc, thay vì khẳng định mọi thành phần đã production-ready.

---

# 12) Context về giá trị của đề tài

Bạn nên chốt phần này thật rõ.

## 12.1 Giá trị kỹ thuật

Đề tài cho phép kiểm chứng một hệ IoT nhiều lớp gồm:

* wireless embedded layer
* gateway layer
* messaging layer
* cloud/app layer

## 12.2 Giá trị thực tiễn

Case **light / switch / occupancy** là một bài toán gần thực tế, dễ hiểu, dễ demo, và có thể mở rộng thành:

* energy saving
* room automation
* security scene
* smart building control

## 12.3 Giá trị học thuật

Đề tài thể hiện năng lực ở nhiều mặt:

* firmware
* networking
* message contract design
* distributed system thinking
* integration testing
* extensibility planning

---

# 13) Dàn ý context bạn có thể dùng thẳng cho báo cáo

Dưới đây là **khung viết Chương 1** rất hợp với dự án của bạn.

## 1. Tổng quan đề tài

### 1.1 Bối cảnh và lý do chọn đề tài

* nhu cầu smart home / smart building
* vấn đề của hệ thống nhiều node
* vì sao cần local network + remote control
* vì sao chọn Zigbee

### 1.2 Mục tiêu của đề tài

* xây dựng hệ thống end-to-end
* local control + remote monitoring/control
* có gateway, cloud, mobile app
* có khả năng mở rộng OTA

### 1.3 Phạm vi triển khai

* node: light, switch, occupancy sensor
* gateway: Linux laptop, sau này Raspberry Pi
* cloud: state + command + history
* app: Flutter
* chưa đi sâu production-scale

### 1.4 Đối tượng hướng tới

* người dùng cuối trong smart home
* người vận hành / kỹ thuật viên
* nhóm phát triển cần nền tảng dễ mở rộng

### 1.5 Phương pháp tiếp cận

* thiết kế theo kiến trúc nhiều lớp
* local-first
* contract-first
* phát triển từng vertical slice end-to-end

### 1.6 Ý nghĩa khoa học và thực tiễn

* kiểm chứng kiến trúc IoT nhiều lớp
* thể hiện khả năng tích hợp embedded + cloud + app
* có tiềm năng mở rộng thành hệ thống lớn hơn

---

# 14) Bản mô tả context ngắn gọn, có thể đưa thẳng vào báo cáo

Bạn có thể dùng đoạn này gần như nguyên văn:

> Đề tài hướng tới xây dựng một hệ thống smart home dựa trên kiến trúc IoT nhiều lớp, trong đó lớp local sử dụng mạng Zigbee để kết nối các node như light, switch và occupancy sensor; lớp trung gian sử dụng gateway chạy trên Linux để bridge dữ liệu giữa Zigbee và cloud; lớp trên cùng gồm cloud backend và mobile application phục vụ giám sát, điều khiển và mở rộng dịch vụ. Mục tiêu của hệ thống không chỉ dừng ở việc điều khiển thiết bị đơn lẻ, mà là kiểm chứng toàn bộ luồng dữ liệu end-to-end từ sensing, command dispatch, state synchronization đến khả năng mở rộng như automation, event logging và OTA. Với hướng tiếp cận này, đề tài vừa mang giá trị thực tiễn trong bối cảnh smart home/smart building, vừa mang giá trị kỹ thuật khi kết hợp embedded firmware, wireless networking, gateway software, cloud integration và mobile application trong cùng một hệ thống.

---

# 15) Chốt ngắn gọn

Phần **context** của dự án này nên làm rõ 5 ý:

* đây là **bài toán hệ thống**, không phải bài toán 1 node
* Zigbee là **local network layer**
* gateway là **trục xương sống**
* cloud + app là **lớp quản trị và trải nghiệm người dùng**
* OTA, scene, automation là **hướng mở rộng để hệ thống scale về sau**

