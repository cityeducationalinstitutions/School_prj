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
        description="Built on strong foundations and a legacy of trust, we nurture young minds through quality education, modern learning, and values that last a lifetime."
        image="/about/hero_students_planting.jpg"
      />
      <AboutIntro />
      <ApproachSection />
      <Differentiators />
      <TimelineSection />
    </div>
  );
};

export default About;
