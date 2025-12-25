'use client'

import { useState, useEffect } from 'react'
import { getAthletes, getProgramsForAthlete, getWorkoutsForAthleteProgram } from '@/lib/supabase-queries'
import WorkoutView from '../components/WorkoutView'
import { WorkoutRecord } from '@/types/workout'

interface Program {
  program_name: string
  start_date: string
}

export default function BrowsePage() {
  const [selectedAthlete, setSelectedAthlete] = useState<string | null>(null)
  const [selectedProgram, setSelectedProgram] = useState<string | null>(null)
  const [athletes, setAthletes] = useState<string[]>([])
  const [programs, setPrograms] = useState<Program[]>([])
  const [workouts, setWorkouts] = useState<WorkoutRecord[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  // Load athletes on mount
  useEffect(() => {
    const loadAthletes = async () => {
      setLoading(true)
      setError(null)
      try {
        const data = await getAthletes()
        setAthletes(data)
      } catch (err) {
        console.error('Error loading athletes:', err)
        setError('Failed to load athletes')
      } finally {
        setLoading(false)
      }
    }

    loadAthletes()
  }, [])

  // Load programs when athlete is selected
  useEffect(() => {
    if (!selectedAthlete) {
      setPrograms([])
      return
    }

    const loadPrograms = async () => {
      setLoading(true)
      setError(null)
      try {
        const data = await getProgramsForAthlete(selectedAthlete)
        setPrograms(data)
      } catch (err) {
        console.error('Error loading programs:', err)
        setError('Failed to load programs')
      } finally {
        setLoading(false)
      }
    }

    loadPrograms()
  }, [selectedAthlete])

  // Load workouts when program is selected
  useEffect(() => {
    if (!selectedAthlete || !selectedProgram) {
      setWorkouts([])
      return
    }

    const loadWorkouts = async () => {
      setLoading(true)
      setError(null)
      try {
        const data = await getWorkoutsForAthleteProgram(selectedAthlete, selectedProgram)
        setWorkouts(data)
      } catch (err) {
        console.error('Error loading workouts:', err)
        setError('Failed to load workouts')
      } finally {
        setLoading(false)
      }
    }

    loadWorkouts()
  }, [selectedAthlete, selectedProgram])

  const handleAthleteSelect = (athlete: string) => {
    setSelectedAthlete(athlete)
    setSelectedProgram(null) // Reset program selection
  }

  const handleProgramSelect = (programName: string) => {
    setSelectedProgram(programName)
  }

  const formatDate = (dateString: string) => {
    if (!dateString) return ''
    const date = new Date(dateString)
    return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })
  }

  const handleBackToAthletes = () => {
    setSelectedAthlete(null)
    setSelectedProgram(null)
  }

  const handleBackToPrograms = () => {
    setSelectedProgram(null)
  }

  return (
    <div style={{
      padding: '20px',
      fontFamily: 'Arial, sans-serif',
      maxWidth: '1400px',
      margin: '0 auto'
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' }}>
        <h1 style={{ margin: 0, color: '#333' }}>Browse Athletes & Programs</h1>
        <a
          href="/"
          style={{
            padding: '10px 20px',
            fontSize: '14px',
            fontWeight: '600',
            backgroundColor: '#6c757d',
            color: 'white',
            border: 'none',
            borderRadius: '6px',
            textDecoration: 'none',
            transition: 'background-color 0.2s'
          }}
        >
          ← Back to Scraper
        </a>
      </div>

      {/* Breadcrumb navigation */}
      <div style={{ marginBottom: '20px', fontSize: '14px', color: '#666' }}>
        {!selectedAthlete && <span>Select an athlete</span>}
        {selectedAthlete && !selectedProgram && (
          <span>
            <button
              onClick={handleBackToAthletes}
              style={{
                background: 'none',
                border: 'none',
                color: '#0070f3',
                cursor: 'pointer',
                textDecoration: 'underline',
                padding: 0,
                fontSize: '14px'
              }}
            >
              Athletes
            </button>
            {' > '}
            <span style={{ fontWeight: '600' }}>{selectedAthlete.charAt(0).toUpperCase() + selectedAthlete.slice(1)}</span>
            {' > Select a program'}
          </span>
        )}
        {selectedAthlete && selectedProgram && (
          <span>
            <button
              onClick={handleBackToAthletes}
              style={{
                background: 'none',
                border: 'none',
                color: '#0070f3',
                cursor: 'pointer',
                textDecoration: 'underline',
                padding: 0,
                fontSize: '14px'
              }}
            >
              Athletes
            </button>
            {' > '}
            <button
              onClick={handleBackToPrograms}
              style={{
                background: 'none',
                border: 'none',
                color: '#0070f3',
                cursor: 'pointer',
                textDecoration: 'underline',
                padding: 0,
                fontSize: '14px'
              }}
            >
              {selectedAthlete.charAt(0).toUpperCase() + selectedAthlete.slice(1)}
            </button>
            {' > '}
            <span style={{ fontWeight: '600' }}>{selectedProgram}</span>
          </span>
        )}
      </div>

      {/* Error Display */}
      {error && (
        <div style={{
          padding: '15px',
          marginBottom: '20px',
          backgroundColor: '#fee',
          color: '#c33',
          borderRadius: '6px',
          border: '1px solid #fcc'
        }}>
          <strong>Error:</strong> {error}
        </div>
      )}

      {/* Athletes List */}
      {!selectedAthlete && (
        <div style={{
          padding: '20px',
          backgroundColor: '#f8f9fa',
          borderRadius: '8px',
          border: '1px solid #dee2e6'
        }}>
          <h2 style={{ marginBottom: '15px', fontSize: '18px', color: '#333' }}>
            Athletes
          </h2>

          {loading && (
            <p style={{ color: '#666' }}>Loading athletes...</p>
          )}

          {!loading && athletes.length === 0 && (
            <p style={{ color: '#666' }}>
              No athletes found. Push some workout data to the database first.
            </p>
          )}

          {!loading && athletes.length > 0 && (
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))',
              gap: '10px'
            }}>
              {athletes.map(athlete => (
                <button
                  key={athlete}
                  onClick={() => handleAthleteSelect(athlete)}
                  style={{
                    padding: '15px',
                    fontSize: '16px',
                    fontWeight: '500',
                    backgroundColor: 'white',
                    color: '#333',
                    border: '1px solid #ddd',
                    borderRadius: '6px',
                    cursor: 'pointer',
                    transition: 'all 0.2s',
                    textAlign: 'left'
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.backgroundColor = '#0070f3'
                    e.currentTarget.style.color = 'white'
                    e.currentTarget.style.borderColor = '#0070f3'
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.backgroundColor = 'white'
                    e.currentTarget.style.color = '#333'
                    e.currentTarget.style.borderColor = '#ddd'
                  }}
                >
                  {athlete.charAt(0).toUpperCase() + athlete.slice(1) || '(No name)'}
                </button>
              ))}
            </div>
          )}
        </div>
      )}

      {/* Programs List */}
      {selectedAthlete && !selectedProgram && (
        <div style={{
          padding: '20px',
          backgroundColor: '#f8f9fa',
          borderRadius: '8px',
          border: '1px solid #dee2e6'
        }}>
          <h2 style={{ marginBottom: '15px', fontSize: '18px', color: '#333' }}>
            Programs for {selectedAthlete.charAt(0).toUpperCase() + selectedAthlete.slice(1)}
          </h2>

          {loading && (
            <p style={{ color: '#666' }}>Loading programs...</p>
          )}

          {!loading && programs.length === 0 && (
            <p style={{ color: '#666' }}>No programs found for this athlete.</p>
          )}

          {!loading && programs.length > 0 && (
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))',
              gap: '10px'
            }}>
              {programs.map(program => (
                <button
                  key={program.program_name}
                  onClick={() => handleProgramSelect(program.program_name)}
                  style={{
                    padding: '15px',
                    fontSize: '16px',
                    fontWeight: '500',
                    backgroundColor: 'white',
                    color: '#333',
                    border: '1px solid #ddd',
                    borderRadius: '6px',
                    cursor: 'pointer',
                    transition: 'all 0.2s',
                    textAlign: 'left'
                  }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.backgroundColor = '#10b981'
                    e.currentTarget.style.color = 'white'
                    e.currentTarget.style.borderColor = '#10b981'
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.backgroundColor = 'white'
                    e.currentTarget.style.color = '#333'
                    e.currentTarget.style.borderColor = '#ddd'
                  }}
                >
                  <div style={{ fontWeight: '600', marginBottom: '5px' }}>
                    {program.program_name}
                  </div>
                  {program.start_date && (
                    <div style={{ fontSize: '13px', color: 'inherit', opacity: 0.8 }}>
                      Start: {formatDate(program.start_date)}
                    </div>
                  )}
                </button>
              ))}
            </div>
          )}
        </div>
      )}

      {/* Workout View */}
      {selectedAthlete && selectedProgram && (
        <div>
          {loading && (
            <p style={{ color: '#666' }}>Loading workouts...</p>
          )}

          {!loading && workouts.length > 0 && <WorkoutView data={workouts} />}

          {!loading && workouts.length === 0 && (
            <p style={{ color: '#666' }}>No workouts found for this program.</p>
          )}
        </div>
      )}
    </div>
  )
}
