const admin = require("firebase-admin");
const serviceAccount = require("./read-quest-51cbb-firebase-adminsdk-fbsvc-bf1b61339f.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const readingId = "the_necklace";

const quizData = {
  easy: [
    {
      id: "q1",
      question: "What item does Mathilde borrow for the event?",
      options: ["A dress", "A necklace", "A ring", "Shoes"],
      correctAnswer: "A necklace",
      explanation: "The necklace is the borrowed item central to the story.",
      order: 1,
      subDifficulty: "low",
      skill: "comprehension",
    },
    {
      id: "q2",
      question: "Who is the main character?",
      options: [
        "Mathilde Loisel",
        "Jeanne Forestier",
        "Monsieur Loisel",
        "Madame Roland",
      ],
      correctAnswer: "Mathilde Loisel",
      explanation: "Mathilde Loisel is the protagonist of the story.",
      order: 2,
      subDifficulty: "low",
      skill: "comprehension",
    },
    {
      id: "q3",
      question: "Where does Mathilde attend the event?",
      options: ["A wedding", "A ball", "A meeting", "A dinner"],
      correctAnswer: "A ball",
      explanation: "She attends a grand ball hosted by the Ministry.",
      order: 1,
      subDifficulty: "mid",
      skill: "comprehension",
    },
    {
      id: "q4",
      question: "Who lends Mathilde the necklace?",
      options: ["Her mother", "Her husband", "Madame Forestier", "A stranger"],
      correctAnswer: "Madame Forestier",
      explanation: "Madame Forestier is her wealthy friend.",
      order: 2,
      subDifficulty: "mid",
      skill: "comprehension",
    },
    {
      id: "q5",
      question: "What happens to the necklace after the ball?",
      options: ["It breaks", "It is lost", "It is stolen", "It is returned"],
      correctAnswer: "It is lost",
      explanation: "Mathilde realizes the necklace is missing after the ball.",
      order: 1,
      subDifficulty: "high",
      skill: "comprehension",
    },
    {
      id: "q6",
      question: "What do Mathilde and her husband do after losing the necklace?",
      options: ["Ignore it", "Buy a replacement", "Tell the truth", "Call police"],
      correctAnswer: "Buy a replacement",
      explanation: "They replace it to avoid embarrassment.",
      order: 2,
      subDifficulty: "high",
      skill: "comprehension",
    },
  ],

  normal: [
    {
      id: "q1",
      question: "Why does Mathilde borrow the necklace?",
      options: ["To impress others", "To sell it", "To hide it", "To give it away"],
      correctAnswer: "To impress others",
      explanation: "She wants to appear wealthy and elegant.",
      order: 1,
      subDifficulty: "low",
      skill: "comprehension",
    },
    {
      id: "q2",
      question: "How does Mathilde feel about her life at the beginning?",
      options: ["Satisfied", "Happy", "Dissatisfied", "Excited"],
      correctAnswer: "Dissatisfied",
      explanation: "She dreams of wealth and luxury.",
      order: 2,
      subDifficulty: "low",
      skill: "vocabulary",
    },
    {
      id: "q3",
      question: "What is the consequence of replacing the necklace?",
      options: ["They become rich", "They live in debt", "They move away", "They gain fame"],
      correctAnswer: "They live in debt",
      explanation: "They spend years repaying the cost.",
      order: 1,
      subDifficulty: "mid",
      skill: "comprehension",
    },
    {
      id: "q4",
      question: "How does Mathilde’s life change after losing the necklace?",
      options: ["Becomes luxurious", "Becomes difficult", "Becomes boring", "Becomes exciting"],
      correctAnswer: "Becomes difficult",
      explanation: "She lives a hard life due to debt.",
      order: 2,
      subDifficulty: "mid",
      skill: "comprehension",
    },
    {
      id: "q5",
      question: "What does Mathilde realize at the end?",
      options: ["The necklace was fake", "The necklace was expensive", "She was lucky", "She was right"],
      correctAnswer: "The necklace was fake",
      explanation: "It was only costume jewelry.",
      order: 1,
      subDifficulty: "high",
      skill: "comprehension",
    },
    {
      id: "q6",
      question: "What lesson does the ending suggest?",
      options: ["Honesty is important", "Wealth is everything", "Appearance is reality", "Luxury brings happiness"],
      correctAnswer: "Honesty is important",
      explanation: "Their suffering could have been avoided.",
      order: 2,
      subDifficulty: "high",
      skill: "vocabulary",
    },
  ],

  hard: [
    {
      id: "q1",
      question: "What character flaw leads to Mathilde’s downfall?",
      options: ["Greed", "Pride", "Kindness", "Fear"],
      correctAnswer: "Pride",
      explanation: "Her desire for status causes her problems.",
      order: 1,
      subDifficulty: "low",
      skill: "vocabulary",
    },
    {
      id: "q2",
      question: "What does the necklace symbolize?",
      options: ["Truth", "Deception", "Love", "Friendship"],
      correctAnswer: "Deception",
      explanation: "It appears valuable but is not.",
      order: 2,
      subDifficulty: "low",
      skill: "vocabulary",
    },
    {
      id: "q3",
      question: "Why is the story considered ironic?",
      options: ["They gain wealth", "They suffer for nothing", "They travel abroad", "They win something"],
      correctAnswer: "They suffer for nothing",
      explanation: "The necklace was fake all along.",
      order: 1,
      subDifficulty: "mid",
      skill: "vocabulary",
    },
    {
      id: "q4",
      question: "How does the story critique society?",
      options: ["It praises wealth", "It criticizes social class obsession", "It ignores class", "It supports luxury"],
      correctAnswer: "It criticizes social class obsession",
      explanation: "Mathilde values appearance over reality.",
      order: 2,
      subDifficulty: "mid",
      skill: "comprehension",
    },
    {
      id: "q5",
      question: "What is the central theme of the story?",
      options: ["Love conquers all", "Pride and illusion lead to suffering", "Friendship is powerful", "Wealth brings peace"],
      correctAnswer: "Pride and illusion lead to suffering",
      explanation: "Mathilde’s desires lead to years of hardship.",
      order: 1,
      subDifficulty: "high",
      skill: "comprehension",
    },
    {
      id: "q6",
      question: "What could have prevented their suffering?",
      options: ["Working harder", "Being honest immediately", "Borrowing more", "Ignoring the loss"],
      correctAnswer: "Being honest immediately",
      explanation: "Truth would have avoided years of debt.",
      order: 2,
      subDifficulty: "high",
      skill: "comprehension",
    },
  ],
};

async function seedQuiz() {
  for (const [difficulty, questions] of Object.entries(quizData)) {
    const difficultyRef = db
      .collection("readings")
      .doc(readingId)
      .collection("quizzes")
      .doc(difficulty);

    await difficultyRef.set({ name: difficulty }, { merge: true });

    for (const q of questions) {
      await difficultyRef.collection("questions").doc(q.id).set(q);
      console.log(`Seeded ${difficulty}/${q.id}`);
    }
  }

  console.log("Quiz seeding complete.");
}

seedQuiz().catch(console.error);