import AboutHero from '../components/About/AboutHero';
import AboutIntro from '../components/About/AboutIntro';
import ApproachSection from '../components/About/ApproachSection';
import Differentiators from '../components/About/Differentiators';
import TimelineSection from '../components/About/TimelineSection';

const About = () => {
  return (
    <div className="flex flex-col">
      <AboutHero 
        title="About"
        subtitle="City Educational Institutions"
        description="At City Educational Institutions, we provide a transformative learning experience that combines academic rigor, character development, and innovative thinking — preparing students to excel in a dynamic and competitive world."
        image="/about_students_v1.png"
      />
      <AboutIntro />
      <ApproachSection />
      <Differentiators />
      <TimelineSection />
    </div>
  );
};

export default About;
