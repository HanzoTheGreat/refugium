use rand::Rng;

pub fn generate_invite_code() -> String {
    let mut rng = rand::thread_rng();
    let code: String = (0..8)
        .map(|_| {
            let idx = rng.gen_range(0..36);
            if idx < 10 {
                (b'0' + idx) as char
            } else {
                (b'A' + idx - 10) as char
            }
        })
        .collect();
    code
}

pub fn generate_id() -> String {
    uuid::Uuid::new_v4().to_string()
}