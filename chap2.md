# Tóm tắt Chương 2: Cơ sở lý thuyết và công nghệ nền

Tài liệu này tóm tắt ngắn gọn các khái niệm lý thuyết và công nghệ cốt lõi được trình bày trong [04a_ch2_lythuyet.tex](file:///d:/CODE/Latex/DATN_rp/final-rp/sections/04a_ch2_lythuyet.tex) của báo cáo Đồ án Tốt nghiệp Hệ thống IoT Zigbee Smart Building.

---

## 2.1 Tổng quan IoT và Smart Building
* **Internet of Things (IoT):** Mạng lưới thiết bị kết hợp cảm biến, cơ cấu chấp hành và truyền thông không dây phục vụ trao đổi dữ liệu.
* **Mô hình dòng dữ liệu khép kín trong Smart Building:**
  1. **Thu thập dữ liệu (Sensing):** Cảm biến (nhiệt độ, ánh sáng, chuyển động) đo đạc môi trường.
  2. **Truyền dẫn (Communication):** Truyền không dây cục bộ về Gateway.
  3. **Xử lý trung tâm (Processing) & Giám sát (Monitoring):** Gateway xử lý dữ liệu và đồng bộ lên Cloud dashboard.
  4. **Ra quyết định điều khiển (Control):** Lệnh từ Cloud gửi xuống cơ cấu chấp hành (đèn, rơ-le) đổi trạng thái môi trường.

## 2.2 Giao thức truyền thông Zigbee
* **Đặc tính:** Công suất thấp, tốc độ truyền dẫn lý thuyết 250 kbps, tần số 2.4 GHz (chuẩn IEEE 802.15.4). Hệ thống sử dụng **Zigbee 3.0** với stack **EmberZNet (Gecko SDK 4.5.0)** từ Silicon Labs, bảo mật AES-128.
* **Các vai trò thiết bị trong mạng:**
  * **Zigbee Coordinator (ZC):** Thiết bị khởi tạo mạng và quản lý bảo mật (Trust Center). Trong hệ thống, chạy firmware NCP (Network Co-Processor) kết nối qua UART với Gateway. Địa chỉ mặc định là `0x0000`.
  * **Zigbee Router (ZR):** Thiết bị cấp nguồn trực tiếp (luôn thức), định tuyến và chuyển tiếp các gói tin trong mạng mesh (ví dụ: đèn thông minh Z3Light, công tắc Z3Switch).
  * **Zigbee End Device (ZED / SED):** Thiết bị đầu cuối dùng pin, có chế độ ngủ sâu (Sleepy End Device) để tiết kiệm năng lượng (ví dụ: cảm biến hiện diện Occupancy Sensor).
* **Mô hình mạng (Topology):**
  * *Mạng hình sao (Star):* Kết nối trực tiếp với Coordinator trung tâm, dễ quản lý nhưng giới hạn vùng phủ sóng.
  * *Mạng lưới (Mesh):* Định tuyến đa chặng linh hoạt (multi-hop). Có khả năng tự phục hồi (self-healing) qua thuật toán AODV khi một đường truyền vật lý bị lỗi.
  * *Mạng hình cây (Tree):* Phân cấp gốc-nhánh-lá giúp đơn giản hóa việc định địa chỉ.
* **Kiến trúc phân tầng (Protocol Stack):**
  * **PHY Layer:** Điều chế DSSS 2.4 GHz, đo LQI.
  * **MAC Layer:** Quản lý truy cập kênh vô tuyến qua CSMA/CA, kiểm soát lỗi bằng ACK.
  * **NWK Layer:** Cấp phát địa chỉ 16-bit động, xây dựng bảng định tuyến, mã hóa Network Key.
  * **APS Layer:** Cầu nối NWK và ZCL, lọc gói trùng, lưu bảng Binding, phân mảnh bản tin nếu vượt quá MTU (127 bytes).
  * **ZCL Layer:** Thư viện cụm ứng dụng (Cluster Library).
* **Địa chỉ và bảo mật:**
  * **Địa chỉ vật lý EUI-64 (MAC 64-bit):** Cố định duy nhất từ nhà sản xuất, được dùng làm khóa định danh chính (Primary Key) đồng bộ lên database Cloud và MQTT.
  * **Địa chỉ mạng 16-bit (NwkAddr):** Cấp phát động khi gia nhập mạng, có thể thay đổi nên chỉ dùng cho định tuyến nội bộ lớp thấp.
  * **Bảo mật:** Sử dụng *Network Key* (mã hóa dữ liệu trên không) và *Link Key* (mã hóa bảo mật điểm-điểm khi trao đổi khóa ban đầu).
* **Quá trình gia nhập mạng (Join Process):**
  1. *Khám phá mạng (Network Discovery):* Thiết bị con gửi Beacon Request, Coordinator phản hồi bằng Beacon Frame.
  2. *Kết nối vật lý (MAC Association):* Thiết bị con gửi Association Request (EUI-64), Coordinator cấp địa chỉ 16-bit qua Association Response.
  3. *Xác thực và trao đổi khóa:* Coordinator mã hóa và gửi Network Key xuống thiết bị con qua bản tin Transport Key.
  4. *Thông báo (Device Announce):* Thiết bị con phát quảng bá tin báo sự hiện diện của mình cho toàn mạng.

## 2.3 Thư viện cụm ứng dụng Zigbee (ZCL)
* **Cấu trúc hướng đối tượng:**
  * **Cluster (Cụm):** Gom nhóm các thuộc tính và lệnh logic (ví dụ: On/Off Cluster, Temperature Measurement Cluster).
  * **Attribute (Thuộc tính):** Biến trạng thái thực tế của thiết bị (ví dụ: `OnOff` kiểu Boolean, `MeasuredValue`).
  * **Command (Lệnh):** Các hành động gửi tới thiết bị để thực hiện tác vụ (ví dụ: `Toggle`, `Read/Write Attribute`).
* **Mô hình Client/Server:** Server lưu giữ thuộc tính vật lý (ví dụ: Đèn chứa On/Off Server); Client gửi lệnh điều khiển (ví dụ: Công tắc chứa On/Off Client).
* **Cơ chế Binding (Liên kết cục bộ):** Cho phép thiết lập liên kết trực tiếp giữa Endpoint Client của công tắc với Endpoint Server của đèn. Giúp các thiết bị điều khiển trực tiếp lẫn nhau trong mạng nội bộ vô tuyến mà không cần qua Gateway hay Cloud, giảm độ trễ tối đa và đảm bảo hệ thống chạy bình thường khi mất mạng Internet.

## 2.4 Vai trò của Gateway trong hệ thống IoT
* **Thiết bị biên (Edge Device):** Chuyển đổi giao tiếp hai chiều giữa mạng cục bộ (Zigbee RF) và mạng diện rộng (IP).
* **Luồng dữ liệu:**
  * *Chiều lên (Uplink):* Nhận bản tin ZCL nhị phân từ Coordinator qua EZSP/UART, biên dịch thành JSON Payload và publish lên các Topic MQTT lên Cloud.
  * *Chiều xuống (Downlink):* Lắng nghe lệnh điều khiển từ Cloud qua MQTT, giải mã và gửi khung lệnh EZSP xuống Coordinator qua cổng serial.

## 2.5 Giao thức truyền thông MQTT
* **Mô hình Publish/Subscribe:** Loại bỏ kết nối trực tiếp giữa Publisher và Subscriber bằng Broker trung gian (Mosquitto). Dữ liệu được gửi và nhận qua các chủ đề phân cấp (Topics).
* **Mức độ dịch vụ (QoS):**
  * **QoS 0 (At most once):** Gửi 1 lần, không xác nhận. Nhanh nhất nhưng dễ mất mát tin nhắn (dùng cho telemetry phụ).
  * **QoS 1 (At least once):** Đảm bảo tin nhắn đến đích ít nhất 1 lần qua cơ chế PUBACK (dùng cho lệnh điều khiển và trạng thái quan trọng).
  * **QoS 2 (Exactly once):** Đảm bảo đến đúng 1 lần duy nhất qua cơ chế bắt tay 4 bước (không dùng trong đồ án vì tốn tài nguyên).
* **Tính năng nâng cao:**
  * **Retained Message:** Broker lưu lại bản tin cuối cùng của topic và gửi ngay cho client mới subscribe, giúp đồng bộ trạng thái lập tức.
  * **Last Will and Testament (LWT):** "Di chúc" tự động được Broker gửi đi thông báo trạng thái offline khi Gateway bị ngắt kết nối đột ngột (mất điện, mất mạng).

## 2.6 Giao tiếp nối tiếp UART
* **Đặc tả vật lý:** Kết nối Point-to-Point giữa Linux Host (chạy Z3Gateway) và SoC EFR32MG12 (chạy NCP) qua hai đường tín hiệu TX và RX.
* **Cấu hình:** Baud rate mặc định 115200 bps. Sử dụng giao thức **ASH (Asynchronous Serial Host)** của Silicon Labs để đóng khung dữ liệu (framing), kiểm tra lỗi CRC và quản lý luồng dữ liệu (flow control), bảo vệ tính toàn vẹn của gói tin EZSP truyền trên đường UART.

## 2.7 Phần cứng và Kit phát triển sử dụng
* **EFR32MG12 Wireless Starter Kit (WSTK):**
  * **Radio Board BRD4162A:** Chứa SoC EFR32MG12 lõi ARM Cortex-M4 40 MHz, 1024 kB Flash, 256 kB RAM, mạch thu phát +10 dBm 2.4 GHz kèm anten PCB tích hợp.
  * **Mainboard BRD4001A:** Cung cấp mạch nạp J-Link tích hợp để nạp/debug, màn hình LCD, cảm biến nhiệt/ẩm Si7021, nút nhấn BTN0/BTN1, LED0/LED1.
* **Ánh xạ phần cứng thực tế theo vai trò:**
  * **Coordinator/NCP Board:** Kết nối trực tiếp qua USB để làm bộ thu phát Zigbee vật lý cho Gateway Host.
  * **Z3Light Board:** Sử dụng LED0 để mô phỏng trạng thái đèn bật/tắt.
  * **Z3Switch Board:** Sử dụng nút BTN0 để gửi lệnh Toggle bật/tắt đèn qua cơ chế binding cục bộ.
  * **Occupancy Sensor Board:** Cấu hình ở chế độ Sleepy End Device dùng nguồn pin, sử dụng BTN0 để mô phỏng việc phát hiện chuyển động.
