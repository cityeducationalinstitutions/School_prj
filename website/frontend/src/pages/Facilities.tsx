import AboutHero from '../components/About/AboutHero';
import FacilitiesSection from '../components/About/FacilitiesSection';

const Facilities = () => {
  return (
    <div className="flex flex-col">
      <AboutHero 
        title="World-Class"
        subtitle="Facilities"
        description="Explore our state-of-the-art campuses designed to provide the ultimate environment for learning, growth, and safety. From advanced science labs to technology-enabled classrooms, we provide everything your child needs to excel."
        image="/academics_classroom.png"
      />
      <FacilitiesSection />
    </div>
  );
};

export default Facilities;
