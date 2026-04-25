import { useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { BookOpen, MonitorPlay, Focus, ShieldCheck, Microscope, Cpu, Palette, Music } from 'lucide-react';
import SchoolHero from '../components/Campus/SchoolHero';
import LearningPhilosophy from '../components/Campus/LearningPhilosophy';
import MetricsSection from '../components/Campus/MetricsSection';
import HighlightsSection from '../components/Campus/HighlightsSection';
import AcademicsSection from '../components/Campus/AcademicsSection';
import PrincipalMessage from '../components/Campus/PrincipalMessage';

const CAMPUS_CONTENT: Record<string, any> = {
  'city-talent': {
    name: "City Talent",
    heroDescription: "Nurturing creativity and building character. At City Talent, we believe in a holistic approach where arts, literature, and standard academics blend to create well-rounded global citizens.",
    heroImage: "https://images.unsplash.com/photo-1577896851231-70ef18881754?q=80&w=1600",
    philosophy: "We believe in building a foundation that supports both intellectual growth and moral character. Our curriculum is designed to spark curiosity and foster a lifelong love for learning.",
    academicsDesc1: "We follow a rigorous <strong class=\"text-black font-semibold\">CBSE Curriculum</strong> balanced with intensive co-curricular activities in arts and humanities.",
    academicsDesc2: "Our goal is to ensure every student finds their unique voice through specialized workshops and creative mentorship programs.",
    academicsImage: "https://images.unsplash.com/photo-1577896849786-738ed6c78bd3?q=80&w=1200",
    highlights: [
      { icon: <Palette className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Arts Academy", desc: "Dedicated spaces for painting, sculpture, and visual arts to nurture child creativity." },
      { icon: <Music className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Musical Excellence", desc: "Comprehensive training in both classical and contemporary musical instruments." },
      { icon: <BookOpen className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Literary Societies", desc: "Active debating and reading clubs that foster strong communication and analytical skills." },
      { icon: <ShieldCheck className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Value Education", desc: "Strong focus on character building and ethical leadership in every classroom." }
    ],
    principal: {
      name: "Dr. Anjali Verma",
      message: "At City Talent, we see beauty in every child's potential. Our mission is to provide the canvas upon which they can paint their future with confidence and integrity.",
      image: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=800"
    }
  },
  'city-elite': {
    name: "City Elite",
    heroDescription: "The peak of premium education. City Elite offers a high-performance environment with world-class facilities designed for students who aspire toward global leadership and elite excellence.",
    heroImage: "https://images.unsplash.com/photo-1541829070764-84a7d30dd3f3?q=80&w=1600",
    philosophy: "Elite education is about precision, discipline, and advanced mentorship. We provide a hybrid learning environment that bridges traditional values with futuristic methodologies.",
    academicsDesc1: "City Elite proudly implements the revolutionary <strong class=\"text-black font-semibold\">Kerdo Method</strong> for our Pre-KG to Class 2 students, focusing on multisensory cognitive development.",
    academicsDesc2: "For higher grades, we follow a globally aligned CBSE framework with specialized logic and analytical training sessions.",
    academicsImage: "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?q=80&w=1200",
    highlights: [
      { icon: <ShieldCheck className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Elite Infrastructure", desc: "State-of-the-art campus featuring climate-controlled classrooms and premium amenities." },
      { icon: <MonitorPlay className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Hybrid Learning", desc: "Seamless integration of digital platforms with traditional classroom mentorship." },
      { icon: <Focus className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Advanced Sports", desc: "Top-tier athletic facilities for swimming, tennis, and specialized physical training." },
      { icon: <Cpu className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Future Skills", desc: "Focus on leadership, finance, and digital literacy from an early age." }
    ],
    principal: {
      name: "Mr. Vikram Malhotra",
      message: "Excellence is not an act, but a habit. At City Elite, we cultivate that habit through precision, discipline, and the best educational tools available globally.",
      image: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=800"
    }
  },
  'new-vision': {
    name: "New Vision",
    heroDescription: "Driving the future through science and technology. New Vision is the hub for innovators, offering intensive STEM focus and futuristic robotics for the thinkers of tomorrow.",
    heroImage: "https://images.unsplash.com/photo-1564981797816-1043664bf78d?q=80&w=1600",
    philosophy: "We believe in a future driven by inquiry and logic. Our mission is to equip students with the technical skills and scientific mindset required to solve global challenges.",
    academicsDesc1: "Our Science-first curriculum focuses on <strong class=\"text-black font-semibold\">IIT/NEET Foundation</strong> courses starting from Class 6, ensuring competitive excellence.",
    academicsDesc2: "We integrate hands-on laboratory experiences with theoretical physics and chemistry to build a solid engineering and medical foundation.",
    academicsImage: "https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=1200",
    highlights: [
      { icon: <Cpu className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Robotics Labs", desc: "High-tech robotics and AI experimentation labs for building future technology." },
      { icon: <Microscope className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "STEM Research", desc: "Advanced science labs equipped for university-level research and experimentation." },
      { icon: <MonitorPlay className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Coding Bootcamp", desc: "Intensive coding and software development modules for all secondary students." },
      { icon: <ShieldCheck className="w-10 h-10 text-black mb-6" strokeWidth={1} />, title: "Logic & Analytics", desc: "Special sessions dedicated to competitive exam logic and advanced mathematics." }
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
