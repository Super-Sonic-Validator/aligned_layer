//! A simple program to be proven inside the zkVM.
//! Consists in a 5 question multiple choice quiz
//! with 3 possible answers each.

#![no_main]
sp1_zkvm::entrypoint!(main);

pub fn main() {
    // let mut all_correct = check_answer('c');
    // all_correct = all_correct && check_answer('a');
    // all_correct = all_correct && check_answer('b');
    // all_correct = all_correct && check_answer('c');
    // all_correct = all_correct && check_answer('b');
    check_answer('c');
    check_answer('a');
    check_answer('b');
    check_answer('c');
    check_answer('b');
}


fn check_answer(correct_answer: char) {
    let answer = sp1_zkvm::io::read::<char>();
    assert_eq!(answer, correct_answer);
}
