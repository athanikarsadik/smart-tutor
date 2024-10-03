


![Icon](https://github.com/user-attachments/assets/07279a84-58dc-432a-a391-8e7e6c493d51)


## Igninting Minds Through Socratic learning - Where Question Leads to Mastery

**Socrita** is a AI-powered platform that uses the Socratic method to guide learners through a series of thought-provoking questions, fostering deeper understanding and critical thinking. Focused on critical thinking, Socrita encourages users to explore concepts and reach insights through inquiry-based learning.



---

## Table of Contents
- [Prototype](#prototype)
- [Features](#features)
- [Project Scope](#project-scope)
- [Future Opportunities](#future-opportunities)
- [Technology Stack](#technology-stack)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

---

## Prototype
![Screenshot 2024-10-02 234919](https://github.com/user-attachments/assets/da5d1c70-0596-4400-aa03-e806d6aecb51)
![Desktop - 1](https://github.com/user-attachments/assets/1f5a907f-8581-4a2b-b861-807367a9f7aa)
![Desktop - 1 (1)](https://github.com/user-attachments/assets/56b912ac-fa35-40e9-9554-2790983f4725)
![Desktop - 2](https://github.com/user-attachments/assets/cd417a13-23ba-4893-9bed-0c38a022d796)
---

## Features

- **Socratic Dialogue Engine:** AI-driven question sequences based on user responses, tailored to individual progress.
- **Multimodal Input:** Accepts text, audio and image-based inputs to engage learners in interactive learning experiences.
- **Personalized Learning Paths:** Generates learning paths that adapt to the user's level and understanding.
  
---

## Project Scope

**In-Scope:**
- AI-powered Socratic questioning engine.
- Support for text and image input.
- Customizable learning pathways.
- Web-based platform for learning.
- Feedback and progress tracking.

**Out of Scope (for initial release):**
- Direct lectures or explanations.
- Grading or assessments.
- Full subject curriculum coverage.
- Real-time collaboration with others.
- Native mobile applications.

---

## Future Opportunities

Socrita has the potential for future enhancements such as:
- Expanded subject coverage (e.g., humanities, arts).
- Gamification (points, badges, leaderboards).
- Community discussion forums.
- Real-time collaboration with tutors or peers.
- Native iOS/Android apps.
- **Socratica Chrome Extension** for contextual learning while browsing.

---

## Technology Stack

- **Frontend:** Flutter Web
- **Backend:** Python (FastAPI)
- **AI/ML Models:** Vertex AI (Gemini 1.5 Pro 02 -[Fine-Tuned])
- **Voice Integration:** Deepgram (text-to-speech)
- **Database:** Firebase
- **Deployment:** Vercel and Google Cloud Service

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/socrita.git
   ```

2. Navigate to the project directory:
   ```bash
   cd socrita
   ```

3. Install the required dependencies:
   ```bash
   flutter pub get
   ```

4. Set up the backend (FastAPI):
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

5. Run the Flutter web project:
   ```bash
   flutter run -d chrome
   ```

6. Run the FastAPI backend:
   ```bash
   uvicorn main:app --reload
   ```

---

## Usage

Once installed, the web application will be accessible at `localhost:8080`. Users can:
- Input text or upload images to receive Socratic questions and responses.
- Follow a personalized learning path.
- Track progress with feedback loops.

---

## License

This project is licensed under the **Socrita Proprietary License**. The use of this code is restricted, and no portion of this repository may be copied, modified, distributed, or sold without explicit permission from the authors. Unauthorized cloning of this project is prohibited.

Please read the full license [here](LICENSE).

```markdown
© 2024 Socrita. All Rights Reserved.
```

---

## Contact

For any questions or suggestions, feel free to reach out to the **Socrita Team** algorithmalliance6174@gmail.com.

---

Feel free to modify this template according to the specifics of your project!
