//
//  Debounce + RemoveDuplicates.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation
import Combine

extension Published.Publisher {
    /// Converts a Combine `@Published` Publisher into an `AsyncStream`.
    /// This lets you use `for await` with a `@Published` property.
    func values() -> AsyncStream<Output> {
        AsyncStream { continuation in
            // Subscribe to the Combine publisher.
            let cancellable = self.sink { value in
                continuation.yield(value)
            }

            // Cancel Combine subscription when the stream ends.
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
}

// MARK: - Internal actor for debouncing task state
/// Manages the currently pending debounce task in a thread-safe way using Swift's concurrency model.
/// This actor ensures only one debounce task is active at a time and safely cancels old ones.
private actor DebounceState {
    private var task: Task<Void, Never>?

    /// Replace the current task with a new one, canceling any previous.
    func set(_ newTask: Task<Void, Never>?) {
        task?.cancel()
        task = newTask
    }

    /// Cancel the current task if any.
    func cancel() {
        task?.cancel()
    }
}

// MARK: - AsyncSequence Debounce Extension

extension AsyncSequence {
    /// Debounces emissions from the sequence by only yielding the most recent element
    /// after no new elements have been received within the specified time interval.
    ///
    /// - Parameter interval: The debounce interval (in seconds).
    /// - Returns: A new AsyncStream that emits debounced values.
    func debounce(for interval: TimeInterval) -> AsyncStream<Element> {
        AsyncStream { continuation in
            // Create a state manager actor to store and cancel pending debounce tasks safely.
            let state = DebounceState()

            // Start a Task to consume the original async sequence.
            Task {
                do {
                    // Iterate through all values in the original async sequence.
                    for try await value in self {
                        // For each new value, create a new debounce task.
                        let task = Task {
                            // Wait for the debounce interval (e.g., 0.5 seconds).
                            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))

                            // If the task wasn't cancelled during the sleep, yield the value.
                            continuation.yield(value)
                        }

                        // Replace the current task with this one (and cancel the previous).
                        await state.set(task)
                    }

                    // Finish the stream after the original sequence completes.
                    continuation.finish()

                } catch {
                    // If an error occurs in the original sequence, finish the stream.
                    continuation.finish()
                }
            }

            // Cancel the debounce task if the stream consumer stops listening early.
            continuation.onTermination = { _ in
                Task {
                    await state.cancel()
                }
            }
        }
    }
}

extension AsyncSequence where Element: Equatable {
    /// Prevents consecutive duplicate values from being emitted by the sequence.
    func removeDuplicates() -> AsyncStream<Element> {
        AsyncStream { continuation in
            Task {
                var previous: Element?

                do {
                    for try await value in self {
                        // Only yield the value if it's different from the last one.
                        if value != previous {
                            continuation.yield(value)
                            previous = value
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish()
                }
            }
        }
    }
}

