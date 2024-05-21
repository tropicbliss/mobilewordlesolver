use crate::{
    algorithm,
    helper::{Correctness, Guess, LetterBox},
};

pub struct RustLetterBox {
    pub char: char,
    pub state: Correctness,
}

fn process_outer(state: Vec<[RustLetterBox; 5]>) -> Vec<Guess> {
    state
        .into_iter()
        .map(|word| Guess {
            inner: word.map(|lb| LetterBox {
                char: lb.char.to_ascii_lowercase() as u8,
                state: lb.state,
            }),
        })
        .collect()
}

pub fn is_word(word: String) -> bool {
    algorithm::check_word(word.to_ascii_lowercase())
}

pub fn compute(state: Vec<[RustLetterBox; 5]>, hard_mode: bool) -> Option<String> {
    let inner_repr = process_outer(state);
    algorithm::guess(&inner_repr, hard_mode).map(|s| s.to_ascii_uppercase())
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
