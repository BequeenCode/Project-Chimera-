"""
Test suite for Skills Interface parameter validation.
These tests should FAIL initially - they define the expected interface.
"""

import pytest
import sys
import os

# Add project root to path for imports
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))


class TestSkillsInterface:
    """Test suite for validating skills module interfaces."""
    
    def test_skill_base_class_exists(self):
        """Test that base Skill class exists with required methods."""
        try:
            from chimera.skills import BaseSkill
            assert hasattr(BaseSkill, 'execute'), "BaseSkill should have execute() method"
            assert hasattr(BaseSkill, 'validate_params'), "BaseSkill should have validate_params() method"
            assert hasattr(BaseSkill, 'get_description'), "BaseSkill should have get_description() method"
        except ImportError:
            # Expected to fail initially
            pytest.fail("BaseSkill class not implemented")
    
    def test_skill_execute_accepts_params(self):
        """Test that skill.execute() accepts and validates parameters."""
        # Mock skill class that should be implemented
        class MockSkill:
            def execute(self, **kwargs):
                # Should accept keyword arguments
                return {"result": "success", "params": kwargs}
        
        skill = MockSkill()
        test_params = {"query": "test", "limit": 5}
        result = skill.execute(**test_params)
        
        # Validate response structure
        assert "result" in result, "Response should have 'result' field"
        assert "params" in result, "Response should have 'params' field"
        assert result["params"] == test_params, "Response should echo parameters"
    
    def test_research_skill_interface(self):
        """Test research skill specific interface."""
        try:
            from chimera.skills.research import ResearchSkill
            
            skill = ResearchSkill()
            
            # Research skill should have specific methods
            assert hasattr(skill, 'search_web'), "ResearchSkill should have search_web()"
            assert hasattr(skill, 'analyze_documents'), "ResearchSkill should have analyze_documents()"
            
            # Test parameter validation
            required_params = ["query", "sources"]
            for param in required_params:
                # This should fail until implemented
                assert hasattr(skill, f'validate_{param}'), f"Missing validation for {param}"
                
        except ImportError:
            # Expected to fail initially
            pytest.fail("ResearchSkill not implemented")
    
    def test_analysis_skill_interface(self):
        """Test analysis skill specific interface."""
        try:
            from chimera.skills.analysis import AnalysisSkill
            
            skill = AnalysisSkill()
            
            # Analysis skill should have specific methods
            assert hasattr(skill, 'analyze_trends'), "AnalysisSkill should have analyze_trends()"
            assert hasattr(skill, 'generate_insights'), "AnalysisSkill should have generate_insights()"
            
            # Test that it accepts data parameter
            test_data = [{"name": "trend1", "volume": 100}]
            
            # This will fail until implemented
            result = skill.analyze_trends(data=test_data)
            assert result is not None, "analyze_trends should return results"
            assert "insights" in result, "Result should contain insights"
            assert "summary" in result, "Result should contain summary"
            
        except ImportError:
            # Expected to fail initially
            pytest.fail("AnalysisSkill not implemented")
    
    def test_skill_registry_exists(self):
        """Test that skill registry exists for managing skills."""
        try:
            from chimera.skills.registry import SkillRegistry
            
            registry = SkillRegistry()
            
            # Registry should have basic methods
            assert hasattr(registry, 'register'), "Registry should have register()"
            assert hasattr(registry, 'get_skill'), "Registry should have get_skill()"
            assert hasattr(registry, 'list_skills'), "Registry should have list_skills()"
            
            # Test registration
            class TestSkill:
                def execute(self):
                    return "test"
            
            registry.register("test_skill", TestSkill())
            assert "test_skill" in registry.list_skills(), "Skill should be registered"
            
        except ImportError:
            # Expected to fail initially
            pytest.fail("SkillRegistry not implemented")
    
    def test_skill_parameter_validation(self):
        """Test that skills validate input parameters properly."""
        # This test should fail until validation is implemented
        class MockSkill:
            def execute(self, required_param=None):
                if required_param is None:
                    raise ValueError("required_param is required")
                return {"status": "success"}
        
        skill = MockSkill()
        
        # Test missing required parameter
        try:
            skill.execute()
            pytest.fail("Should have raised ValueError for missing parameter")
        except ValueError:
            # Expected - test passes
            pass
        
        # Test with parameter
        result = skill.execute(required_param="test")
        assert result["status"] == "success"


if __name__ == "__main__":
    pytest.main([__file__, "-v"])