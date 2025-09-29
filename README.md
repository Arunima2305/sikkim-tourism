# Sikkim Tourism Prototype (Flutter)

Features included in this prototype:
- **OpenStreetMap** via `flutter_map` with markers for major monasteries.
- **Guide booking** flow with availability check and a **mock payment** step.
- **Event calendar** using `table_calendar` with sample events.
- **Virtual tour** placeholders ready for later 360° / Unity integration.
- Mobile‑optimized UI for Android and iOS (Material 3).

## Quick start
```bash
flutter pub get
flutter run
```
> If you target iOS, open Xcode after `flutter create .` if needed.

## Notes
- Payments are simulated in `PaymentService`; wire up Razorpay/Stripe in production.
- Add more monasteries in `lib/data/monasteries.dart`.
- Add more events in `lib/data/events.dart`.
