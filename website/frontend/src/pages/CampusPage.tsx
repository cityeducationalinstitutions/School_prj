import { useEffect } from 'react';
import { useParams } from 'react-router-dom';
import SchoolHero from '../components/Campus/SchoolHero';
import LearningPhilosophy from '../components/Campus/LearningPhilosophy';
import MetricsSection from '../components/Campus/MetricsSection';
import HighlightsSection from '../components/Campus/HighlightsSection';
import AcademicsSection from '../components/Campus/AcademicsSection';
import PrincipalMessage from '../components/Campus/PrincipalMessage';

import idea3d from '../assets/icons/idea_3d_v2.png';
import compass3d from '../assets/icons/compass_3d_v2.png';
import users3d from '../assets/icons/users_3d_v2.png';
import heart3d from '../assets/icons/heart_3d_v2.png';

// Highlight Icons
import literature3d from '../assets/icons/literature_3d.png';
import valuesEdu3d from '../assets/icons/values_edu_3d.png';
import robotics3d from '../assets/icons/robotics_3d.png';
import stem3d from '../assets/icons/stem_3d.png';
import sports3d from '../assets/icons/sports_3d.png';
import infra3d from '../assets/icons/infra_3d.png';
import tech3d from '../assets/icons/tech_3d.png';
import growth3d from '../assets/icons/growth_3d.png';

const CAMPUS_CONTENT: Record<string, any> = {
  'city-talent': {
    name: "City Talent",
    heroDescription: "Our educational philosophy focuses on developing a strong learning attitude in students, empowering them to excel in any field they choose. We emphasize concept-based learning and practical understanding, enabling students to apply knowledge confidently in real-world situations. At the same time, we nurture critical thinking, creativity, and strong values, helping students grow into confident, responsible, and future-ready individuals.",
    heroImage: "/schools/city_talent_campus.jpg",
    philosophy: "Our educational philosophy focuses on developing a strong learning attitude in students, empowering them to excel in any field they choose. We emphasize concept-based learning and practical understanding, enabling students to apply knowledge confidently in real-world situations. At the same time, we nurture critical thinking, creativity, and strong values, helping students grow into confident, responsible, and future-ready individuals.",
    philosophyItems: [
      {
        icon: <img src={idea3d} alt="Concept-Based" className="w-10 h-10 object-contain scale-[1.7]" />,
        title: "Concept-Based Learning",
        desc: "We focus on deep understanding of core concepts rather than rote memorization, enabling students to apply knowledge with clarity and confidence."
      },
      {
        icon: <img src={compass3d} alt="Practical" className="w-10 h-10 object-contain scale-[1.7]" />,
        title: "Practical Understanding",
        desc: "We bridge the gap between theory and real-world application through hands-on learning, experiments, and experiential activities."
      },
      {
        icon: <img src={users3d} alt="Engagement" className="w-10 h-10 object-contain scale-[1.7]" />,
        title: "Student Engagement",
        desc: "We create interactive learning environments that encourage participation, curiosity, and independent thinking."
      },
      {
        icon: <img src={heart3d} alt="Holistic" className="w-10 h-10 object-contain scale-[1.7]" />,
        title: "Holistic Development",
        desc: "We nurture emotional intelligence, physical well-being, and strong moral values to ensure all-round growth."
      }
    ],
    academicsDesc1: "We follow a structured State (SSC) curriculum built on strong academic foundations and practical understanding. Our approach emphasizes conceptual clarity, consistent practice, and real-world application to ensure students achieve both academic success and life readiness.",
    academicsDesc2: "Through focused teaching, disciplined learning, and continuous guidance, we help every student build confidence, perform with excellence, and grow with purpose.",
    academicsImage: "/indian_classroom_collaboration.png",
    highlights: [
      { icon: <img src={literature3d} alt="Literature" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Literary Societies", desc: "Active reading, writing, and debating platforms strengthen communication skills, critical thinking, and intellectual confidence." },
      { icon: <img src={valuesEdu3d} alt="Values" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Value Education", desc: "A strong emphasis on ethics, discipline, and character development shapes responsible, respectful, and principled individuals." },
      { icon: <img src={sports3d} alt="Sports" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Sports & Physical Development", desc: "Structured sports programs promote teamwork, physical fitness, discipline, and a competitive spirit essential for overall growth." },
      { icon: <img src={growth3d} alt="Growth" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Holistic Growth", desc: "A balanced focus on intellectual, emotional, and personal development helps students grow into confident and well-rounded individuals." }
    ],
    principal: {
      name: "Dr. Anjali Verma",
      message: "At City Talent, we see beauty in every child's potential. Our mission is to provide the canvas upon which they can paint their future with confidence and integrity.",
      image: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=800"
    }
  },
  'city-elite': {
    name: "City Elite",
    heroDescription: "Empowering future-ready learners through innovation, technology, and modern teaching methodologies. We inspire students to think critically, adapt confidently, and excel in a rapidly evolving world.",
    heroImage: "/schools/city_elite_campus.jpg",
    philosophy: "Elite education is about precision, discipline, and advanced mentorship. We provide a hybrid learning environment that bridges traditional values with futuristic methodologies.",
    academicsDesc1: "City Elite proudly implements the revolutionary <strong class=\"text-black font-semibold\">Kerdo Method</strong> for our Pre-KG to Class 2 students, focusing on multisensory cognitive development.",
    academicsDesc2: "For higher grades, we follow a globally aligned CBSE framework with specialized logic and analytical training sessions.",
    academicsImage: "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?q=80&w=1200",
    highlights: [
      { icon: <img src={infra3d} alt="Infrastructure" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Elite Infrastructure", desc: "State-of-the-art campus featuring climate-controlled classrooms and premium amenities." },
      { icon: <img src={tech3d} alt="Hybrid" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Hybrid Learning", desc: "Seamless integration of digital platforms with traditional classroom mentorship." },
      { icon: <img src={sports3d} alt="Sports" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Advanced Sports", desc: "Top-tier athletic facilities for swimming, tennis, and specialized physical training." },
      { icon: <img src={idea3d} alt="Skills" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Future Skills", desc: "Focus on leadership, finance, and digital literacy from an early age." }
    ],
    principal: {
      name: "Mr. Vikram Malhotra",
      message: "Excellence is not an act, but a habit. At City Elite, we cultivate that habit through precision, discipline, and the best educational tools available globally.",
      image: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=800"
    }
  },
  'new-vision': {
    name: "New Vision",
    heroDescription: "Delivering excellence through advanced academics, disciplined learning, and leadership-focused development. We prepare students to achieve high performance with confidence, clarity, and a strong sense of responsibility.",
    heroImage: "https://images.unsplash.com/photo-1564981797816-1043664bf78d?q=80&w=1600",
    philosophy: "We believe in a future driven by inquiry and logic. Our mission is to equip students with the technical skills and scientific mindset required to solve global challenges.",
    academicsDesc1: "Our Science-first curriculum focuses on <strong class=\"text-black font-semibold\">IIT/NEET Foundation</strong> courses starting from Class 6, ensuring competitive excellence.",
    academicsDesc2: "We integrate hands-on laboratory experiences with theoretical physics and chemistry to build a solid engineering and medical foundation.",
    academicsImage: "https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=1200",
    highlights: [
      { icon: <img src={robotics3d} alt="Robotics" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Robotics Labs", desc: "High-tech robotics and AI experimentation labs for building future technology." },
      { icon: <img src={stem3d} alt="STEM" className="w-14 h-14 object-contain scale-[1.5]" />, title: "STEM Research", desc: "Advanced science labs equipped for university-level research and experimentation." },
      { icon: <img src={tech3d} alt="Coding" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Coding Bootcamp", desc: "Intensive coding and software development modules for all secondary students." },
      { icon: <img src={compass3d} alt="Logic" className="w-14 h-14 object-contain scale-[1.5]" />, title: "Logic & Analytics", desc: "Special sessions dedicated to competitive exam logic and advanced mathematics." }
    ],
    principal: {
      name: "Dr. Sanjay Roy",
      message: "The innovators of tomorrow are born from the curiosity of today. At New Vision, we provide the tools and the challenges to turn that curiosity into discovery.",
      image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=800"
    }
  }
};

export default function CampusPage() {
  const { campusId } = useParams<{ campusId: string }>();
  
  // Default to city-talent if not found or no ID
  const content = (campusId && CAMPUS_CONTENT[campusId]) ? CAMPUS_CONTENT[campusId] : CAMPUS_CONTENT['city-talent'];

  // Scroll to top when campus changes
  useEffect(() => {
    window.scrollTo(0, 0);
  }, [campusId]);

  return (
    <div className="bg-brand-light">
      <SchoolHero 
        campusName={content.name} 
        description={content.heroDescription}
        image={content.heroImage}
      />
      
      <LearningPhilosophy 
        description={content.philosophy}
        items={content.philosophyItems}
      />
      
      <MetricsSection />
      
      <HighlightsSection 
        highlights={content.highlights}
      />
      
      <AcademicsSection 
        description1={content.academicsDesc1}
        description2={content.academicsDesc2}
        image={content.academicsImage}
      />
      
      <PrincipalMessage 
        campusName={content.name} 
        principalName={content.principal.name}
        principalImage={content.principal.image}
        principalQuote={content.principal.message}
      />
    </div>
  );
}
