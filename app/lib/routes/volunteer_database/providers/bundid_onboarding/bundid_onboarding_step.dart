/// Steps of the BundID onboarding flow. Profile fields are always editable; only the phone/SMS
/// part is gated, since the phone number always needs to be SMS-verified before it can be used
/// as a merge key with a future SMS registration.
enum BundIdOnboardingStep { phone, sms }
